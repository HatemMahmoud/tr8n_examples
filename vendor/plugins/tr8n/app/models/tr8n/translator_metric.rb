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

class Tr8n::TranslatorMetric < ActiveRecord::Base
  set_table_name :tr8n_translator_metrics

  belongs_to :translator, :class_name => "Tr8n::Translator"
  belongs_to :language, :class_name => "Tr8n::Language"
  
  def self.find_or_create(translator, language)
    if language
      tm = find(:first, :conditions => ["translator_id = ? and language_id = ?", translator.id, language.id])
    else
      tm = find(:first, :conditions => ["translator_id = ? and language_id is null", translator.id])
    end
    
    return tm if tm
    create(:translator => translator, :language => language, :total_translations => 0, :total_votes => 0, :positive_votes => 0, :negative_votes => 0)
  end
  
  # updated when an action is done by the translator
  def update_metrics!
    if language
      self.total_translations = Tr8n::Translation.count(:conditions=>["translator_id = ? and language_id = ?", translator.id, language.id])
      self.total_votes = Tr8n::TranslationVote.count(:conditions=>["tr8n_translation_votes.translator_id = ? and tr8n_translations.language_id = ?", translator.id, language.id], 
                                               :joins => "INNER JOIN tr8n_translations ON tr8n_translations.id = tr8n_translation_votes.translation_id")
      self.positive_votes = Tr8n::TranslationVote.count(:conditions=>["tr8n_translation_votes.translator_id = ? and tr8n_translation_votes.vote > 0 and tr8n_translations.language_id = ?", translator.id, language.id],
                                               :joins => "INNER JOIN tr8n_translations ON tr8n_translations.id = tr8n_translation_votes.translation_id")
      self.negative_votes = self.total_votes - self.positive_votes
    else
      self.total_translations = Tr8n::Translation.count(:conditions=>["translator_id = ?", translator.id])
      self.total_votes = Tr8n::TranslationVote.count(:conditions=>["translator_id = ?", translator.id])
      self.positive_votes = Tr8n::TranslationVote.count(:conditions=>["translator_id = ? and vote > 0", translator.id])
      self.negative_votes = self.total_votes - self.positive_votes
    end
    
    save
  end
  
  # updated when an action is done to the translator's translations
  def update_rank!
    if language
      self.accepted_translations = Tr8n::Translation.count(:conditions => ["translator_id = ? and language_id = ? and rank >= ?", translator.id, language.id, Tr8n::Config.translation_threshold])
      self.rejected_translations = Tr8n::Translation.count(:conditions => ["translator_id = ? and language_id = ? and rank < ?", translator.id, language.id, 0])
    else
      self.accepted_translations = Tr8n::Translation.count(:conditions => ["translator_id = ? and rank >= ?", translator.id, Tr8n::Config.translation_threshold])
      self.rejected_translations = Tr8n::Translation.count(:conditions => ["translator_id = ? and rank < ?", translator.id, 0])
    end
    
    save
  end  
  
  def rank 
    return 0 unless total_translations and accepted_translations
    
    total_translations == 0 ? 0 : (accepted_translations * 100.0/total_translations)
  end
  
  def pending_vote_translations
    return total_translations unless accepted_translations and rejected_translations
    total_translations - accepted_translations - rejected_translations
  end
end
