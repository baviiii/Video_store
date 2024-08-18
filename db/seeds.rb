# Stop Seeds if any records exist in the database.
# Note: This isn't ideal in the fact that if data is created in migrations then this would fail
ActiveRecord::Base.connection.tables.each do |table|
  table = table.classify.constantize rescue nil
  if table && table.respond_to?(:any?) && table != User # skip Devise, we can expect one there
    return if table.any?
  end
end
# Run User setup regardless of whether seeds fail, should be safe to rerun
user = User.where(email: 'developer@mindvision.com.au').find_or_initialize_by(
  admin_role: 'super_user', first_name: 'Mindvision', last_name: 'Interactive')
user.password = "password"
user.password_confirmation ="password"
user.save!(validate: false)

# If something fails prefer to start again based on the above code to avoid re-runs
ActiveRecord::Base.transaction do
  # -- Model seeds start --
  # -- Model seeds end --
end
