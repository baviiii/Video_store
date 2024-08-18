require 'active_support/concern'

module IdReferencing
  extend ActiveSupport::Concern
  # Aplha Numeric ID references
  # WARNING! Changing the array in any way *will* change the values of all previous codes.
  ENCODE_ARRAY = %w(B H N T 3 C J P W 4 D K Q X 6 F L R Y 7 G M S 2 9)

  def encode_id(int_to_encode=nil)
    m = ENCODE_ARRAY.length
    n = int_to_encode || id
    s = ''
    return s if n.blank?
    while s.length < 5 || n > 0
      x = n % m
      n = (n - x) / m
      s = ENCODE_ARRAY[x] + s
    end
    s
  end
  alias_method :reference, :encode_id

  module ClassMethods
    def reference_decode(ref)
      total = 0
      ref.upcase.strip.each_char do |c|
        return nil if !ENCODE_ARRAY.include?(c)
        total *= ENCODE_ARRAY.length
        total += ENCODE_ARRAY.index(c)
      end
      total
    end

    def get_by_reference(ref)
      self.find(self.reference_decode(ref))
    end
  end
end
