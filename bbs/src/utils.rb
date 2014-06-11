require 'cgi'

def escapeText(str)
  str = CGI.escapeHTML(str)
  str.gsub(/\n/, '<br>')
end
