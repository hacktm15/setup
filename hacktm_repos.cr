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
    /repo: (.*)/.match(body)
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

items = Array(Item).from_json(response.body)
items.each do |x|
  if x.valid?
    puts x.to_s
  end
end
