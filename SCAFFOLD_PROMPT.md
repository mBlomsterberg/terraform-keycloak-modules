# Scaffold a Terraform module in the `terraform-aws-modules` convention

Create a new Terraform module repository named `terraform-<PROVIDER>-<NAME>`
(e.g. `terraform-aws-eks`) that follows the exact structure, naming, and
documentation conventions described below. Ask me for `<PROVIDER>`, `<NAME>`,
and the list of resources the module manages before generating files if I
haven't already given them.

## Root layout

Split resources across multiple logically-named `.tf` files at the root rather
than one giant `main.tf`. Required root files:

- `main.tf`        — primary/core resources for the module
- `<feature>.tf`   — one file per logical resource group (e.g. `endpoints.tf`,
                     `iam.tf`, `events.tf`, `certificates.tf`). Name them after
                     the concept, not the resource type.
- `variables.tf`   — all input variables (every variable MUST have a
                     `description` and an explicit `type`)
- `outputs.tf`     — all outputs (every output MUST have a `description`)
- `versions.tf`    — `terraform` required_version (`>= 1.0`) and
                     `required_providers` with pinned minimum versions
- `README.md`      — see README structure below
- `LICENSE`        — Apache-2.0
- `CHANGELOG.md`   — managed by semantic-release; seed with the title only
- `.gitignore`, `.editorconfig`

## Conventions for the module code

- Gate all resource creation on a `create` bool variable (`var.create`), and
  use per-feature toggles like `create_<feature>` where it makes sense.
- Accept collections of sub-resources as **maps of objects** (e.g.
  `endpoints = {}`, typed `any` or a concrete object type) and create them with
  `for_each`. Use the map **keys** as the cross-reference mechanism between
  resources (e.g. a task references an endpoint by its map key).
- Name resources `this` when there's a single logical instance per module.
- Always support a `tags` map applied to all resources, plus per-resource
  `<resource>_tags` overrides.

## Sub-modules (`/modules`)

A module MAY contain nested sub-modules under `modules/<submodule-name>/`. Each
sub-module is a self-contained module with its own
`main.tf` / `variables.tf` / `outputs.tf` / `versions.tf` / `README.md`,
following all the same conventions as the root module. The root module may call
these sub-modules, and they may also be consumed independently. Add a
`modules/README.md` if the relationship between sub-modules needs explanation.

## Wrappers (`/wrappers`)

Provide a `wrappers/` folder that lets users loop over the module (or a
sub-module) to create many instances from a single map. For each wrappable
module create:

- `wrappers/main.tf` — calls the target module with
  `for_each = var.items`, passing each value's attributes through with
  `try(each.value.<attr>, var.defaults.<attr>, <fallback>)` so callers can set
  shared `defaults` plus per-item overrides.
- `wrappers/variables.tf` — `defaults` (a map/object, default `{}`) and
  `items` (a map of objects, default `{}`).
- `wrappers/outputs.tf` — `output "wrapper"` returning the whole keyed map of
  module instances: `value = module.wrapper`.
- `wrappers/versions.tf` and `wrappers/README.md`.

If there are sub-modules, mirror this under
`wrappers/<submodule-name>/`.

## Examples (`/examples`)

- `examples/README.md` — boilerplate explaining examples serve two purposes
  (working references + a way to test/validate module changes) and a note that
  they are not "best practices".
- One sub-directory per scenario (e.g. `examples/complete/`,
  `examples/<variant>/`). Each contains `main.tf`, `variables.tf`,
  `outputs.tf`, `versions.tf`, a `README.md`, and any supporting config files
  (e.g. a `configs/` dir for JSON).
- Each example's `README.md` starts with a short
  "Configuration in this directory creates:" bullet list, a `## Usage` section
  with `terraform init/plan/apply`, a cost warning + `terraform destroy` note,
  then a `<!-- BEGIN_TF_DOCS -->` / `<!-- END_TF_DOCS -->` block, then the
  Apache-2.0 license line.
- Examples reference the local module via `source = "../.."` (and sub-modules
  via `../../modules/<name>`).

## Tooling / CI

- `.pre-commit-config.yaml` using `antonbabenko/pre-commit-terraform` with
  hooks: `terraform_fmt`, `terraform_docs` (`--lockfile=false`),
  `terraform_tflint` (with the standard `--only` rule set incl.
  `terraform_standard_module_structure`, `terraform_documented_variables`,
  `terraform_documented_outputs`, `terraform_typed_variables`,
  `terraform_naming_convention`, `terraform_required_version`,
  `terraform_required_providers`), and `terraform_validate`; plus
  `pre-commit/pre-commit-hooks`: `check-merge-conflict`, `end-of-file-fixer`,
  `trailing-whitespace`.
- `.releaserc.json` configuring semantic-release (conventional commits) with
  commit-analyzer, release-notes-generator, github, changelog (CHANGELOG.md),
  and git plugins; release commit message
  `chore(release): version ${nextRelease.version} [skip ci]`.
- `.github/workflows/` with: `pre-commit.yml`, `release.yml`,
  `pr-title.yml` (conventional-commit PR title lint), `stale-actions.yaml`,
  and `lock.yml`.

## README.md structure (root)

Reproduce this section order exactly:

1. `# <Provider> <Name> Terraform module` — title
2. One-sentence description: "Terraform module which creates <...> resources."
3. `## Usage` — link to `examples` dir, then a single representative `hcl`
   code block showing a realistic `module "..."` call with the main inputs.
4. Topic sections explaining how the map-key cross-referencing works and any
   important concepts (mirror the style of "Combinations" / "Tasks": prose +
   trimmed `hcl` snippets, optionally images under `.github/images/`).
5. `## Examples` — boilerplate paragraph + a bulleted list linking to each
   example directory.
6. `<!-- BEGIN_TF_DOCS -->` ... `<!-- END_TF_DOCS -->` — leave this block in
   place; it is auto-generated by `terraform-docs` and contains Requirements,
   Providers, Modules, Resources, Inputs, and Outputs tables.
7. `## License` — "Apache-2.0 Licensed. See [LICENSE](./LICENSE)."

If the module has sub-modules, add a `## Submodules` (or similar) section
linking to each `modules/<name>` directory, and document the `wrappers/` usage
under a short section near Usage.

Generate every file with real, valid content (not placeholders) for the
resources I specify. Run `terraform fmt` conventions (2-space indent, aligned
`=`). Leave the `terraform-docs` markers empty/auto-generated rather than
hand-writing the tables.
