require 'spec_helper'
require 'importeroo/importer'

describe Importeroo::Importer do
  with_model :BicycleType do
    table do |t|
      t.string :bicycle_type
    end
  end

  describe "#import!" do
    context "when a CSV" do
      it "deletes old data and imports the new data" do
        BicycleType.create(id: 5, bicycle_type: "velocipede")

        described_class.new(BicycleType, "CSV", "spec/fixtures/bicycles.csv").import!

        BicycleType.count.should == 4
        BicycleType.find(1).bicycle_type.should == "road bike"
        BicycleType.find(2).bicycle_type.should == "mountain bike"
        BicycleType.find(3).bicycle_type.should == "touring bike"
        BicycleType.find(4).bicycle_type.should == "beach cruiser"

        BicycleType.all.map(&:bicycle_type).should_not include("velocipede")
      end
    end

    context "when an Excel file" do
      it "deletes old data and imports the new data" do
        BicycleType.create(id: 5, bicycle_type: "velocipede")

        described_class.new(BicycleType, "Excelx", "spec/fixtures/bicycles.xlsx").import!

        BicycleType.count.should == 4
        BicycleType.find(1).bicycle_type.should == "road bike"
        BicycleType.find(2).bicycle_type.should == "mountain bike"
        BicycleType.find(3).bicycle_type.should == "touring bike"
        BicycleType.find(4).bicycle_type.should == "beach cruiser"

        BicycleType.all.map(&:bicycle_type).should_not include("velocipede")
      end
    end
  end
end
