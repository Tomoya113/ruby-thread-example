class Hoge 
  def initialize
    @hoge = "hoge"
    self.fuga(@hoge)
  end

  def fuga(hoge)
    p hoge
    self.fuga(hoge)
  end

  def test
    self.fuga
  end

end

hoge = Hoge.new
# hoge.test()