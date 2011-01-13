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

class Tr8n::TranslationDomain < ActiveRecord::Base
  set_table_name :tr8n_translation_domains
  
  has_many    :translation_sources,       :class_name => "Tr8n::TranslationSource",     :dependent => :destroy
  has_many    :translation_key_sources,   :class_name => "Tr8n::TranslationKeySource",  :through => :translation_sources
  has_many    :translation_keys,          :class_name => "Tr8n::TranslationKey",        :through => :translation_key_sources
  
  alias :sources      :translation_sources
  alias :key_sources  :translation_key_sources
  alias :keys         :translation_keys
  
  def self.find_or_create(url)
    domain_name = URI.parse(url || 'localhost').host || 'localhost'
    Tr8n::Cache.fetch("translation_domain_#{domain_name}") do 
      find_by_name(domain_name) || create(:name => domain_name)
    end  
  end
  
  def after_save
    Tr8n::Cache.delete("translation_domain_#{name}")
  end

  def after_destroy
    Tr8n::Cache.delete("translation_domain_#{name}")
  end
  
end
