require 'json'
require 'github/markup'
require 'nokogiri'
path = File.dirname(__FILE__) # get this file path so relative paths can be used

# read in the json post data
post_data = JSON.parse(File.open(path + '/post_data/2021-02-23-test.json').read)

# read the post template into a nokogiri object
@doc = Nokogiri::HTML(File.open(path + '/page_templates/post.html').read)

# set the title tag and page header
@doc.at_css("title").content = post_data['title']
@doc.at_css("h1").content = post_data['title']

# convert post body content from markdown to html, create node, attach it to "main"
puts post_data['body']
puts "*******************"
body = GitHub::Markup.render_s(GitHub::Markups::MARKUP_MARKDOWN, post_data['body'])
body_content_node = Nokogiri::XML::Node.new(body, @doc)
puts body
main = @doc.at_css "main"
body_content_node.parent = main
File.write(path + '/public/posts/post2.html', @doc, mode: "w")
