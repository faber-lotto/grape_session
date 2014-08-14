require 'acceptance_spec_helper'

feature 'Create a configuration with an DSL' do
  subject do
    Class.new do
      include GrapeSession::Configuration.module(:config1, :config2, config3: [:config4], config5: [config6: [:config7, :config8]])
    end
  end

  scenario 'Set nested configs' do
    subject.configure do
      config1 'alpha'
      config2 'beta'

      config3 do
        config4 'gamma'
      end

      config5 do
        config6 do
          config7 7
          config8 8
        end
      end
    end

    expect(subject.settings).to eq(config1: 'alpha',
                                   config2: 'beta',
                                   config3: { config4: 'gamma' },
                                   config5: { config6: { config7: 7, config8: 8 } }
                                   )
  end

end
