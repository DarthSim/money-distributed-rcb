require 'money-distributed'
require 'savon'

class Money
  module Distributed
    module Fetcher
      # Russian Central Bank rates fetcher
      class RussianCentralBank
        include Base

        CBR_SERVICE_URL =
          'http://www.cbr.ru/DailyInfoWebServ/DailyInfo.asmx?WSDL'.freeze

        private

        def exchange_rates
          fetch_exchange_rates.each_with_object('RUB' => 1) do |rate, h|
            next unless local_currencies.include? rate[:vch_code]
            h[rate[:vch_code]] =
              BigDecimal(rate[:vnom]) / BigDecimal(rate[:vcurs])
          end
        end

        def fetch_exchange_rates
          client = Savon::Client.new(
            wsdl: CBR_SERVICE_URL, log: false, log_level: :error,
            follow_redirects: true
          )
          response = client.call(
            :get_curs_on_date,
            message: { 'On_date' => Time.now.strftime('%Y-%m-%dT%H:%M:%S') }
          )
          response.body[:get_curs_on_date_response][:get_curs_on_date_result] \
                       [:diffgram][:valute_data][:valute_curs_on_date]
        end

        def local_currencies
          @local_currencies ||=
            Money::Currency.table.map { |currency| currency.last[:iso_code] }
        end
      end
    end
  end
end
