#!/usr/bin/env ruby

require 'plist'

class Bookmarks
  def initialize(path)
    @path = path
    @plist_hash = Plist.parse_xml(`plutil -convert xml1 -o - #{@path}`)
    @plist_hash['Children'] = [] if @plist_hash['Children'].nil?
  end

  def folder_names
    @plist_hash['Children'].collect {|b| b['Title']}
  end

  def reset_capi_folder
    @capi_folder_index = if folder_names.include? 'CAPI'
              capi_folder_index = folder_names.find_index {|f| f == 'CAPI'}
              capi_folder = @plist_hash['Children'][capi_folder_index]
              capi_folder['Children'] = []
              capi_folder_index
            else
              @plist_hash['Children'].push(
                { 'Title' => 'CAPI',
                  'WebBookmarkType' => 'WebBookmarkTypeList',
                  'Children' => []
                })
              @plist_hash['Children'].count - 1
            end
  end

  def insert_links_into_capi_folder(new_links)
    capi_folder = @plist_hash['Children'][@capi_folder_index]
    capi_folder_links = capi_folder['Children']

    new_links.each do |name, url|
      capi_folder_links.push(bookmark_hash_for(name, url))
    end
  end

  def write_file
    File.open(@path, 'w') {|f| f.write @plist_hash.to_plist}
  end

  private

  def bookmark_hash_for(name, url)
    {'ReadingListNonSync' =>
      {'neverFetchMetadata' => false},
      'URIDictionary' =>
        {'title' => name},
      'URLString' => url,
      'WebBookmarkType' => 'WebBookmarkTypeLeaf',
      'previewText' => '',
      'previewTextIsUserDefined' => true}
  end
end

bookmarks = Bookmarks.new(File.join(ENV['HOME'], 'Library', 'Safari', 'Bookmarks.plist'))
bookmarks.reset_capi_folder
bookmarks.insert_links_into_capi_folder(
  {
    'CAPI Trello' => 'http://board.capi.land',
    'Connor' => 'http://braa.capi.land',
    'Chris' => 'http://chris.capi.land',
    'CI' => 'https://ci.capi.land',
    'Elena' =>'http://elena.capi.land',
    'Greg' => 'http://greg.capi.land',
    'Mike' => 'http://mike.capi.land',
    'Tim' => 'http://tim.capi.land',
    'Video' =>'http://video.capi.land',
    'Capi Zoom' => 'http://zoom.capi.land',
  }
)
bookmarks.write_file

# Open Safari to re-read new links, then close
`open -a "Safari"`
sleep 2
`osascript -e 'quit app "Safari"'`
