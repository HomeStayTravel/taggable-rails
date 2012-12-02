module Taggable
  module Tagged
    extend ActiveSupport::Concern

    included do
      has_many :taggings, :as => :tagged, :dependent => :destroy, :include => :tag
      has_many :tags, :through => :taggings, :dependent => :destroy do
        def tagged_by(tagger)
          where(:taggings => {:tagger_id => tagger.id, :tagger_type => tagger.class.name})
        end
      end
    end

    def tag(opts)
      raise("You need to specify tags using :with") unless opts.has_key?(:with)

      tags   = opts[:with].is_a?(Array) ? opts[:with] : [opts[:with]]
      tagger = opts[:by]

      tags.each do |tag|
        taggings << ::Tagging.new(:tag => tag, :tagger => tagger)
      end
    end
  end
end