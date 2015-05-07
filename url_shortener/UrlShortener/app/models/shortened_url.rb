class ShortenedUrl < ActiveRecord::Base


  belongs_to(
    :submitter,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id
  )

  has_many :visits, class_name: "Visit", foreign_key: :short_url_id, primary_key: :id
  has_many :visitors, -> { distinct } ,through: :visits, source: :user

  validates :short_url, :uniqueness => true, :presence => true
  validates :user_id, :presence => true

  def self.random_code
    random_code = SecureRandom.base64(16)

    if ShortenedUrl.exists?(:short_url => random_code)
      ShortenedUrl.random_code
    else
      random_code
    end
  end

  def self.create_for_user_and_long_url!(user, long_url)
    short_url = ShortenedUrl.random_code
    ShortenedUrl.create!(:long_url => long_url, :short_url => short_url,:user_id => user.id)
  end

  def num_clicks
    self.visits.count
  end

  def num_uniques
    self.visitors.count
  end

  def num_recent_uniques
    self.visitors.where('visits.created_at > ?', Time.now - 360.minutes).count
  end

end
