require 'clamp'

module Tagfish
  module CLI

    class BaseCommand < Clamp::Command

      option ["-d", "--debug"], :flag, "debug API calls"

    end

  end
end
