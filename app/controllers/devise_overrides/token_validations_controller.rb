class DeviseOverrides::TokenValidationsController < DeviseTokenAuth::TokenValidationsController
  def validate_token

    # debug to see what is in  @resource
    Rails.logger.debug("@Resource: #{@resource.inspect}")

    # @resource will have been set by set_user_by_token concern
    if @resource
      render 'devise/token', formats: [:json]
    else
      render_validate_token_error
    end
  end
end
