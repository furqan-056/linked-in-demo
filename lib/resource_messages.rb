module ResourceMessages
  DEFAULT_SUCCESS_MESSAGES = {
    created: 'Created successfully',
    updated: 'Updated successfully',
    deleted: 'Deleted successfully'
  }.freeze

  DEFAULT_ERROR_MESSAGES = {
    not_found: 'Resource not found',
    default: 'Operation failed'
  }.freeze

  RESOURCE_SUCCESS_MESSAGES = {
    company: { created: 'Company created', updated: 'Company updated', deleted: 'Company deleted' },
    job:     { created: 'Job posted', updated: 'Job updated', deleted: 'Job removed' }
  }.freeze

  RESOURCE_ERROR_MESSAGES = {
    company: { not_found: 'Company not found' },
    job:     { not_found: 'Job not found' }
  }.freeze

  def self.for_success(resource, action)
    RESOURCE_SUCCESS_MESSAGES.fetch(resource.to_sym, {}).fetch(action, DEFAULT_SUCCESS_MESSAGES[action] || 'Operation completed')
  end

  def self.for_error(resource, action)
    RESOURCE_ERROR_MESSAGES.fetch(resource.to_sym, {}).fetch(action, DEFAULT_ERROR_MESSAGES[action] || DEFAULT_ERROR_MESSAGES[:default])
  end
end
