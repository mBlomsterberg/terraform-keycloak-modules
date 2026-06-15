# Setting up Keycloak for Terraform

This guide walks through starting the local Keycloak stack and creating a dedicated service-account client for the Terraform provider to authenticate with. Using a dedicated client is preferred over supplying admin credentials directly — it limits the blast radius if the secret is rotated or leaked and makes it easier to audit what Terraform has changed.

## Prerequisites

- Docker Desktop (or Docker Engine + Compose plugin)
- Terraform ≥ 1.3

---

## 1. Start the stack

```sh
docker compose up --build -d
```

This builds the Keycloak image (with PostgreSQL driver baked in) and starts both containers. Keycloak is ready when its health endpoint responds:

```sh
curl -s http://localhost:9000/health/ready
# {"status":"UP", ...}
```

Or watch the compose health status:

```sh
docker compose ps
# NAME               STATUS
# keycloak           Up (healthy)
# keycloak_postgres  Up (healthy)
```

---

## 2. Create the Terraform client

Pick one approach. Both produce the same result: a `terraform` client in the `master` realm whose service account holds the `admin` role.

### Option A — Admin UI

1. Open **http://localhost:8080** and sign in with `admin` / `admin`.
2. Make sure the realm selector (top-left) is set to **master**.
3. Go to **Clients → Create client**.
   - **Client type**: OpenID Connect
   - **Client ID**: `terraform`
   - Click **Next**.
4. On the **Capability config** screen:
   - Turn **Client authentication** ON (makes it confidential).
   - Turn **Service accounts roles** ON.
   - Leave everything else off.
   - Click **Next → Save**.
5. Open the **Credentials** tab. Copy the **Client secret** — you will need it in step 3.
6. Open the **Service accounts roles** tab → **Assign role**.
   - Change the filter to **Filter by realm roles**.
   - Select **admin** → **Assign**.

### Option B — kcadm.sh (scriptable)

Run the following from your terminal. The script authenticates, creates the client, and assigns the `admin` role to its service account in one pass.

```sh
# 1. Authenticate the CLI against the running container
docker exec keycloak /opt/keycloak/bin/kcadm.sh config credentials \
  --server http://localhost:8080 \
  --realm master \
  --user admin \
  --password admin

# 2. Create the terraform client
docker exec keycloak /opt/keycloak/bin/kcadm.sh create clients \
  --realm master \
  -s clientId=terraform \
  -s enabled=true \
  -s publicClient=false \
  -s serviceAccountsEnabled=true \
  -s 'secret=terraform-client-secret'

# 3. Grant the admin realm role to the service account
docker exec keycloak /opt/keycloak/bin/kcadm.sh add-roles \
  --realm master \
  --uusername service-account-terraform \
  --rolename admin
```

> **Secret rotation**: to change the secret later, go to **Clients → terraform → Credentials → Regenerate** in the UI, or run:
> ```sh
> docker exec keycloak /opt/keycloak/bin/kcadm.sh generate-client-secret \
>   --realm master \
>   --target clients/$(docker exec keycloak /opt/keycloak/bin/kcadm.sh get clients \
>     --realm master -q clientId=terraform --fields id | grep '"id"' | awk -F'"' '{print $4}')
> ```

---

## 3. Configure the Terraform provider

Export the client secret as an environment variable so it stays out of your `.tf` files:

```sh
export KEYCLOAK_CLIENT_SECRET=terraform-client-secret
```

Then add the provider block to your Terraform configuration:

```hcl
terraform {
  required_providers {
    keycloak = {
      source  = "keycloak/keycloak"
      version = ">= 5.7.0"
    }
  }
}

provider "keycloak" {
  client_id     = "terraform"
  client_secret = var.keycloak_client_secret  # or use KEYCLOAK_CLIENT_SECRET env var
  url           = "http://localhost:8080"
}

variable "keycloak_client_secret" {
  type      = string
  sensitive = true
}
```

The provider also reads the following environment variables directly, so the `provider` block can be left with just `url` if you prefer:

| Variable | Value |
|---|---|
| `KEYCLOAK_CLIENT_ID` | `terraform` |
| `KEYCLOAK_CLIENT_SECRET` | your client secret |
| `KEYCLOAK_URL` | `http://localhost:8080` |

Minimal provider block when using env vars:

```hcl
provider "keycloak" {
  url = "http://localhost:8080"
}
```

---

## 4. Verify the connection

```sh
terraform init
terraform plan
```

A successful plan with no errors confirms that the provider can authenticate and reach Keycloak. If you see an authentication error, check:

- The client secret matches what is shown in **Clients → terraform → Credentials**.
- The `terraform` client has **Service accounts roles** enabled (not just standard flows).
- The service account (`service-account-terraform`) has the **admin** realm role under **Service accounts roles**.

---

## Scope the client to a non-master realm (optional)

By default the `admin` role in `master` gives Terraform full control over all realms. If you want to restrict Terraform to a single realm:

1. In the target realm (e.g. `internal`), go to **Clients → Create client** and repeat the steps above, but this time grant **realm-management → realm-admin** rather than the master `admin` role.
2. Update the provider URL to target that realm's token endpoint, or create a second provider alias:

```hcl
provider "keycloak" {
  alias         = "internal"
  url           = "http://localhost:8080"
  client_id     = "terraform"
  client_secret = var.keycloak_client_secret
  realm         = "internal"
}
```

---

## Stopping and resetting

```sh
# Stop without losing data
docker compose down

# Stop and wipe the database (fresh start)
docker compose down -v
```
