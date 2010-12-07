#--
# Copyright (c) 2010 Michael Berkovich, Geni Inc
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#++

module Tr8n::Admin::BaseHelper

  def tr8n_will_filter(results)
    will_filter(results)
  end

  def tr8n_will_paginate(collection = nil, options = {})
    super(collection, options.merge(:skip_decorations => true))
  end

  def tr8n_page_entries_info(collection, options = {})
    super(collection, options.merge(:skip_decorations => true))
  end

  def tr8n_pretty_print_hash(hash)
    return "" unless hash
    html = ""
    hash.each do |key, value|
       html << "<strong>" 
       html << key << ": </strong>"
       if value.is_a?(Hash)
         html << "{"
         html << tr8n_pretty_print_hash(value)
         html << "} "
       else
         html << value.strip if value
         html << "; "
       end
   end
   html
  end
  
end
