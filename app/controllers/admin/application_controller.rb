class Admin::ApplicationController < ApplicationController

  layout 'admin'

  before_filter :require_login!

  private

    def current_admin
      @current_admin ||= Administrator.find(session[:admin_id]) unless session[:admin_id].nil?
    end
    helper_method :current_admin

    def require_login!
      reset_session unless session[:last_page_load].present? && session[:last_page_load] > 1.day.ago
      session[:last_page_load] = Time.now
      redirect_to admin_login_url, alert: "Please login to proceed." if current_admin.nil?
    end



end