module ApplicationHelper
  def display_for(role_name)
    yield if current_user.roles.include? Role.where(name: role_name).first
  end

  def access_only?
    # Check to see if the running site should suppress admin and editor controls
    ESSI.config.dig(:essi, :site_usage) == 'access_only'
  end
  
  def matomo_analytics_tag
    return unless ESSI.config.dig :analytics, :enabled
    tag = <<-CODE
    <!-- Matomo -->
    <script type="text/javascript">
      var _paq = window._paq || [];
      /* tracker methods like "setCustomDimension" should be called before "trackPageView" */
      _paq.push(['trackPageView']);
      _paq.push(['enableLinkTracking']);
      (function() {
        var u="#{ESSI.config.dig :analytics, :url}/";
        _paq.push(['setTrackerUrl', u+'piwik.php']);
        _paq.push(['setSiteId', '#{ESSI.config.dig :analytics, :site_id}']);
        var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0];
        g.type='text/javascript'; g.async=true; g.defer=true; g.src=u+'piwik.js'; s.parentNode.insertBefore(g,s);
      })();
    </script>
    <!-- End Matomo Code -->
    CODE
    tag.html_safe
  end
end
