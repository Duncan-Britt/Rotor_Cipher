class Crypt
  ALPHABET_SIZE = 26

  def decrypt(str)
    reset_initial_setting
    str.chars.map do |chr|
      rotate_rotors
      unshift(chr)
    end.join
  end

  def encrypt(str)
    reset_initial_setting
    str.chars.map do |chr|
      rotate_rotors
      shift(chr)
    end.join
  end

  def initialize(s1, s2, s3)
    validate_settings(s1, s2, s3)

    @r1 = s1.ord - 65
    @r2 = s2.ord - 65
    @r3 = s3.ord - 65
    @i1 = r1
    @i2 = r2
    @i3 = r3
  end

  private

  attr_accessor :r1, :r2, :r3
  attr_reader :i1, :i2, :i3

  def reset_initial_setting
    self.r1 = i1
    self.r2 = i2
    self.r3 = i3
  end

  def rotate_rotors
    t2 = r2
    self.r1 = (r1 + 1) % ALPHABET_SIZE
    self.r2 = (r2 + 1) % 26 if r1 % 3 == 0
    self.r3 = (r3 + 1) % 26 if r1 % 7 == 0
  end

  def rotation
    r1 + r2 + r3
  end

  def shift(chr)
    if /[A-Z]/.match?(chr)
      (((chr.ord - 65 + rotation) % ALPHABET_SIZE) + 65).chr
    elsif /[a-z]/.match?(chr)
      (((chr.ord - 97 + rotation) % ALPHABET_SIZE) + 97).chr
    elsif /[0-9]/.match?(chr)
      (((chr.ord - 48 + rotation) % 10) + 48).chr
    else
      chr
    end
  end

  def unshift(chr)
    if /[A-Z]/.match?(chr)
      (((chr.ord - 65 - rotation) % ALPHABET_SIZE) + 65).chr
    elsif /[a-z]/.match?(chr)
      (((chr.ord - 97 - rotation) % ALPHABET_SIZE) + 97).chr
    elsif /[0-9]/.match?(chr)
      (((chr.ord - 48 - rotation) % 10) + 48).chr
    else
      chr
    end
  end

  def validate_settings(s1, s2, s3)
    unless valid_settings?(s1, s2, s3)
      raise ArgumentError.new("invalid settings")
    end
  end

  def valid_settings?(s1, s2, s3)
    /[A-Z]/.match?(s1) &&
    /[A-Z]/.match?(s2) &&
    /[A-Z]/.match?(s3) &&
    s1.length == 1 &&
    s2.length == 1 &&
    s3.length == 1
  end
end

puts "Enter Rotor Settings:"
setting = gets.chomp
code = Crypt.new(setting[0], setting[1], setting[2])
puts "Enter message"
message = gets.chomp
puts "Encrypt or Decrypt? (e/d)"
case gets.chomp
when 'e' then puts code.encrypt(message)
when 'd' then puts code.decrypt(message)
end
