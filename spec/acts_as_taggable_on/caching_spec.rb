require 'spec_helper'

describe 'Acts As Taggable On' do

  describe 'Caching' do
    before(:each) do
      @taggable = CachedModel.new(name: 'Bob Jones')
      @another_taggable = OtherCachedModel.new(name: 'John Smith')
    end

    it 'should add saving of tag lists and cached tag lists to the instance' do
      expect(@taggable).to respond_to(:save_cached_tag_list)
      expect(@another_taggable).to respond_to(:save_cached_tag_list)

      expect(@taggable).to respond_to(:save_tags)
    end

    it 'should add cached tag lists to the instance if cached column is not present' do
      expect(TaggableModel.new(name: 'Art Kram')).to_not respond_to(:save_cached_tag_list)
    end

    it 'should generate a cached column checker for each tag type' do
      expect(CachedModel).to respond_to(:caching_tag_list?)
      expect(OtherCachedModel).to respond_to(:caching_language_list?)
    end

    it 'should not have cached tags' do
      expect(@taggable.cached_tag_list).to be_blank
      expect(@another_taggable.cached_language_list).to be_blank
    end

    it 'should cache tags' do
      @taggable.update_attributes(tag_list: 'awesome, epic')
      expect(@taggable.cached_tag_list).to eq('awesome, epic')

      @another_taggable.update_attributes(language_list: 'ruby, .net')
      expect(@another_taggable.cached_language_list).to eq('ruby, .net')
    end

    it 'should keep the cache' do
      @taggable.update_attributes(tag_list: 'awesome, epic')
      @taggable = CachedModel.find(@taggable.id)
      @taggable.save!
      expect(@taggable.cached_tag_list).to eq('awesome, epic')
    end

    it 'should update the cache' do
      @taggable.update_attributes(tag_list: 'awesome, epic')
      @taggable.update_attributes(tag_list: 'awesome')
      expect(@taggable.cached_tag_list).to eq('awesome')
    end

    it 'should remove the cache' do
      @taggable.update_attributes(tag_list: 'awesome, epic')
      @taggable.update_attributes(tag_list: '')
      expect(@taggable.cached_tag_list).to be_blank
    end

    it 'should have a tag list' do
      @taggable.update_attributes(tag_list: 'awesome, epic')
      @taggable = CachedModel.find(@taggable.id)
      expect(@taggable.tag_list.sort).to eq(%w(awesome epic).sort)
    end

    it 'should keep the tag list' do
      @taggable.update_attributes(tag_list: 'awesome, epic')
      @taggable = CachedModel.find(@taggable.id)
      @taggable.save!
      expect(@taggable.tag_list.sort).to eq(%w(awesome epic).sort)
    end
  end

  describe 'CachingWithArray' do
    pending '#TODO'
  end
end
