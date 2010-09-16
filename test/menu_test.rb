require File.join(File.dirname(__FILE__), 'test_helper')

describe "Menu.run" do
  def menu(args)
    Menu.run(args)
  end

  shared "parses choices" do
    it 'parses empty choice' do
      mock($stdin).gets { '' }
      mock(Menu).puts []
      menu @args
    end

    it "parses single choice" do
      mock($stdin).gets { '1' }
      mock(Menu).puts ['uno']
      menu @args
    end

    it "parses hyphenated choice" do
      mock($stdin).gets { '1-2' }
      mock(Menu).puts ['uno','dos']
      menu @args
    end

    it "parses comma separated choice" do
      mock($stdin).gets { '1,3' }
      mock(Menu).puts ['uno','tres']
      menu @args
    end

    it "parses asterisk as all choices" do
      mock($stdin).gets { '*' }
      mock(Menu).puts ['uno','dos', 'tres']
      menu @args
    end

    it "aborts with invalid choice" do
      mock($stdin).gets { 'a' }
      mock(Menu).abort(/a' is an invalid choice/) { raise RuntimeError }
      menu(@args) rescue nil
    end

    it "aborts a negative number choice" do
      mock($stdin).gets { '-4' }
      mock(Menu).abort(/-4' is an invalid choice/) { raise RuntimeError }
      menu(@args) rescue nil
    end
  end

  describe "with commandline arguments" do
    before do
      mock($stdin).tty? { true }
      ['1. uno', '2. dos', '3. tres'].each {|e| mock(Menu).puts e }
      mock(Menu).print(anything)
      @args = %w{uno dos tres}
    end

    behaves_like "parses choices"
  end

  describe "with stdin" do
    before do
      mock($stdin).tty? { false }
      mock($stdin).read { "uno\ndos\ntres" }
      ['1. uno', '2. dos', '3. tres'].each {|e| mock(Menu).puts e }
      mock(Menu).print(anything)
    end

    behaves_like "parses choices"
  end
end
