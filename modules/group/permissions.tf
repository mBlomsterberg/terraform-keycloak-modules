resource "keycloak_group_permissions" "this" {
  count = var.create && var.create_permissions ? 1 : 0

  realm_id = var.realm_id
  group_id = keycloak_group.this[0].id

  dynamic "view_scope" {
    for_each = try(var.permissions.view, null) != null ? [var.permissions.view] : []
    content {
      policies          = try(view_scope.value.policies, [])
      description       = try(view_scope.value.description, null)
      decision_strategy = try(view_scope.value.decision_strategy, null)
    }
  }

  dynamic "manage_scope" {
    for_each = try(var.permissions.manage, null) != null ? [var.permissions.manage] : []
    content {
      policies          = try(manage_scope.value.policies, [])
      description       = try(manage_scope.value.description, null)
      decision_strategy = try(manage_scope.value.decision_strategy, null)
    }
  }

  dynamic "view_members_scope" {
    for_each = try(var.permissions.view_members, null) != null ? [var.permissions.view_members] : []
    content {
      policies          = try(view_members_scope.value.policies, [])
      description       = try(view_members_scope.value.description, null)
      decision_strategy = try(view_members_scope.value.decision_strategy, null)
    }
  }

  dynamic "manage_members_scope" {
    for_each = try(var.permissions.manage_members, null) != null ? [var.permissions.manage_members] : []
    content {
      policies          = try(manage_members_scope.value.policies, [])
      description       = try(manage_members_scope.value.description, null)
      decision_strategy = try(manage_members_scope.value.decision_strategy, null)
    }
  }

  dynamic "manage_membership_scope" {
    for_each = try(var.permissions.manage_membership, null) != null ? [var.permissions.manage_membership] : []
    content {
      policies          = try(manage_membership_scope.value.policies, [])
      description       = try(manage_membership_scope.value.description, null)
      decision_strategy = try(manage_membership_scope.value.decision_strategy, null)
    }
  }
}
