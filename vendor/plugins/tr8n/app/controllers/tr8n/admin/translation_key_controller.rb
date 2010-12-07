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

class Tr8n::Admin::TranslationKeyController < Tr8n::Admin::BaseController

  def index
    @keys = Tr8n::TranslationKey.filter(:params => params, :filter => Tr8n::TranslationKeyFilter)
  end

  def view
    @key = Tr8n::TranslationKey.find(params[:key_id])
  end

  def delete
    key = Tr8n::TranslationKey.find_by_id(params[:key_id]) if params[:key_id]
    key.destroy if key
    
    if params[:source] == "key"
      redirect_to(:action => :index)
    else
      redirect_to_source 
    end
  end

  def key_sources
    @key_sources = Tr8n::TranslationKeySource.filter(:params => params, :filter => Tr8n::TranslationKeySourceFilter)
  end

  def sources
    @sources = Tr8n::TranslationSource.filter(:params => params, :filter => Tr8n::TranslationSourceFilter)
  end

  def comments
    @comments = Tr8n::TranslationKeyComment.filter(:params => params, :filter => Tr8n::TranslationKeyCommentFilter)
  end

  def delete_comment
    comment = Tr8n::TranslationKeyComment.find_by_id(params[:comment_id])
    comment.destroy if comment
    
    trfn("Comment has been deleted")
    
    redirect_to_source
  end

  def locks
    @locks = Tr8n::TranslationKeyLock.filter(:params => params, :filter => Tr8n::TranslationKeyLockFilter)
  end
   
   def lb_caller
     @key_source = Tr8n::TranslationKeySource.find(params[:key_source_id])
     @caller = @key_source.details[params[:caller_key]]
     render :layout => false
   end
   
   def reset_verification_flags
     Tr8n::TranslationKey.connection.execute("update tr8n_translation_keys set verified_at = null")
     redirect_to_source
   end
   
   def delete_unverified_keys
     Tr8n::TranslationKey.find(:all, :conditions => "verified_at is null").each do |key|
       next if key.translations.any?
       key.destroy
     end
     redirect_to_source
   end
   
end
