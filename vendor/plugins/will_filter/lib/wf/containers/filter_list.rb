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

class Wf::Containers::FilterList < Wf::FilterContainer

  def self.operators
    [:is_filtered_by]
  end

  def validate
    return "Value must be provided" if value.blank?
  end

  def template_name
    'list'
  end

  def options
    if condition.key == :id
      model_class_name = filter.model_class_name
    else
      model_class_name = condition.key.to_s[0..-4].camelcase
    end
    
    Wf::Filter.new(model_class_name).saved_filters(false)
  end

  def sql_condition
    return nil unless operator == :is_filtered_by
    sub_filter = Wf::Filter.find_by_id(value)
    sub_conds = sub_filter.sql_conditions
    sub_sql = "SELECT #{sub_filter.table_name}.id FROM #{sub_filter.table_name} WHERE #{sub_conds[0]}"
    sub_conds[0] = " #{condition.full_key} IN (#{sub_sql}) "
    sub_conds
  end

end
