require "json"
require "http/client"

class Item
  JSON.mapping({
    body: {type: String},
  })

  def valid?
    (body.includes? "repo:") && (body.includes? "members:")
  end

  def repo
    /repo:\s?(.*)/.match(body)
    $1.strip
  end

  def members
    /members: (.*)?/.match(body)
    $1.strip.split(", ")
  end

  def to_s
    repo + " - " + members.inspect
  end
end

puts "[->] request Github issue #1 comments"
response = HTTP::Client.get("https://api.github.com/repos/hacktm15/setup/issues/1/comments")
json_data = response.body

items = Array(Item).from_json(json_data)
items.each do |x|
  if x.valid?
    puts x.to_s
  end
end
