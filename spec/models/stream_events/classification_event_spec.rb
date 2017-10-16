require 'spec_helper'

describe StreamEvents::ClassificationEvent do
  let(:queue) { double(add: nil) }
  let(:stream) { double(KinesisStream, queue: queue) }
  let(:workflow) { create :workflow }
  let(:hash) do
    {
      "data" => ActionController::Parameters.new("links" => {"workflow" => workflow.id, "subjects" => ["123"]}),
      "linked" => {"subjects" => [{"id" => "123"}]}
    }
  end

  it 'processes an event' do
    workflow.update! extractors_config: {"ext" => {type: "external"}}
    described_class.new(stream, hash).process
    expect(queue).to have_received(:add).once
  end

  it 'does not process when workflow is not in database' do
    workflow.destroy!
    described_class.new(stream, hash).process
    expect(queue).not_to have_received(:add)
  end
end
