module Admin::ProfilesHelper
  def form_for_profile(profile, html_options = {}, &block)
    url = profile.new_record? ?  admin_profiles_url : admin_profile_url(profile)
    html_options[:multipart] = true
    html_options[:method] = :put unless profile.new_record?
    form_for(:profile, @profile, :url => url, :html => html_options, &block)
  end
end
