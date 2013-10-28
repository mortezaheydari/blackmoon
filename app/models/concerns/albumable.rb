module Albumable
  extend ActiveSupport::Concern

  included do

  has_one :album, as: :owner, :dependent => :destroy
  has_one :logo, as: :owner, :dependent => :destroy

  after_create do |this|
      this.create_album if this.album.nil?
      this.create_logo if this.logo.nil?
  end

  has_one :album, as: :owner, :dependent => :destroy
  accepts_nested_attributes_for :album

  has_one :logo, as: :owner, :dependent => :destroy
  accepts_nested_attributes_for :logo

  end

 end