module ProfileTags
  include Radiant::Taggable

  class TagError < StandardError; end

  desc %{
    Causes the tags referring to a profile's attributes to refer to the current profile.

    *Usage:*
    <pre><code><r:profile [name="Scott Summers"]>...</r:profile></code></pre>
  }
  tag 'profile' do |tag|
    if tag.attr['name']
      name = tag.attr['name'].split(' ')
      last_name = name.pop
      first_name = name.join(' ')
      tag.locals.profile = StaffProfile.find_by_first_name_and_last_name(first_name, last_name)
    end

    raise TagError, "'profile' tag must contain a valid 'name' attribute." unless tag.locals.profile
    tag.expand
  end

  desc %{
    Gives access to the available profiles.
  
    *Usage:*
    <pre><code><r:profiles>...</r:profiles></code></pre>
  }
  tag 'profiles' do |tag|
    tag.locals.profiles = StaffProfile.find(:all, :order => 'last_name, first_name')
    tag.expand
  end

  desc %{
    Cycles through each of the staff profiles. Inside this tag all attribute tags
    are mapped to the current profile. By default only published profiles are included.

    *Usage:* 
    <pre><code><r:profiles:each [status="Published"]>...</r:profiles:each></code></pre>
  }
  tag 'profiles:each' do |tag|
    profiles = tag.locals.profiles

    tag.attr['status'] ||= 'Published' # default
    if tag.attr['status'] && (tag.attr['status'].downcase != 'all')
      profiles = profiles.select { |profile| profile.status.name == tag.attr['status'] }
    end

    results = []
    profiles.each do |profile|
      tag.locals.profile = profile
      results << tag.expand
    end
    results
  end

  { :name => :full_name, :title => :title, :email => :email, :biography => :filtered_biography }.each do |name, attr|
    desc %{
      Returns the #{name.to_s} of the staff member.
  
      *Usage:*
      <pre><code><r:profile:#{name.to_s}/></code></pre>
    }
    tag "profile:#{name}" do |tag|
      profile = tag.locals.profile
      profile.send(attr)
    end
  end

  desc %{
    Returns the profile image URL for a staff member.

    *Usage:*
    <pre><code><r:profile:image_url/></code></pre>
  }
  tag 'profile:image_url' do |tag|
    profile = tag.locals.profile
    profile.photo.url(:profile)
  end
end
