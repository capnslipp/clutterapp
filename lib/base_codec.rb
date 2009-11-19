class BaseCodec
  def self.base_n_decode(s, alphabet)
    n = alphabet.length
    rv = pos = 0
    charlist = s.split("").reverse
    charlist.each do |char|
      rv += alphabet.index(char) * n ** pos
      pos += 1
    end
    return rv
  end
  
  def self.base_n_encode(num, alphabet)
    n = alphabet.length
    rv = ""
    while num != 0
      rv = alphabet[num % n, 1] + rv
      num /= n
    end
    
    return rv
  end
  
end
 
class Base30 < BaseCodec
  ALPHABET = "0123456789bcdfghjklmnpqrstvwxz"
  def self.decode(s)
    base_n_decode(s, ALPHABET)
  end
  
  def self.encode(num)
    base_n_encode(num, ALPHABET)
  end
 
end
