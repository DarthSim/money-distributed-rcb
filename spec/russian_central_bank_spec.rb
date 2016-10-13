require 'rspec'
require 'timecop'
require 'webmock/rspec'
require 'money-distributed-rcb'

describe Money::Distributed::Fetcher::RussianCentralBank do
  def read_fixture_file(filename)
    File.read(File.expand_path("../fixtures/#{filename}", __FILE__))
  end

  let(:bank) { double(add_rate: true) }

  let(:soap) { read_fixture_file('soap.xml') }
  let(:response) { read_fixture_file('response.xml') }

  subject { described_class.new(bank) }

  before do
    Timecop.freeze Time.new(2016, 1, 2, 3, 4, 5)

    stub_request(:get, described_class::CBR_SERVICE_URL)
      .to_return(status: 200, body: soap)

    stub_request(:post, 'http://www.cbr.ru/DailyInfoWebServ/DailyInfo.asmx')
      .with(body: /2016-01-02T03:04:05/)
      .to_return(status: 200, body: response)
  end

  it 'fetches rates from Rusian Central Bank' do
    subject.fetch

    # rubocop: disable Metrics/LineLength
    expect(bank).to have_received(:add_rate).with('RUB', 'RUB', BigDecimal('1.0'))
    expect(bank).to have_received(:add_rate).with('USD', 'USD', BigDecimal('1.0'))
    expect(bank).to have_received(:add_rate).with('EUR', 'EUR', BigDecimal('1.0'))
    expect(bank).to have_received(:add_rate).with('RUB', 'USD', BigDecimal('0.0152'))
    expect(bank).to have_received(:add_rate).with('USD', 'RUB', BigDecimal('65.8949'))
    expect(bank).to have_received(:add_rate).with('RUB', 'EUR', BigDecimal('0.0136'))
    expect(bank).to have_received(:add_rate).with('EUR', 'RUB', BigDecimal('73.4596'))
    expect(bank).to have_received(:add_rate).with('USD', 'EUR', BigDecimal('0.897'))
    expect(bank).to have_received(:add_rate).with('EUR', 'USD', BigDecimal('1.1148'))
    # rubocop: enable Metrics/LineLength
  end
end
