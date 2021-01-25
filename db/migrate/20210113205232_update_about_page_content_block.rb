class UpdateAboutPageContentBlock < ActiveRecord::Migration[5.1]
  def up
    cb = ContentBlock.where(name: 'about_page').first
    if cb
      cb.value = "<p>Digital Collections is a growing repository of digital image collections held at Indiana University campuses. While this service will grow to include digital images, digital objects with multiple pages, digital archival materials, and more, it is currently under development and does not yet contain all materials from legacy services offered at Indiana University Bloomington and IUPUI.</p>\r\n<ul>\r\n<li>To view digital image collections, visit <a href=\"http://www.dlib.indiana.edu/collections/images/\" target=\"_blank\" rel=\"noopener\">Image Collections Online.</a></li>\r\n<li>To view IUPUI image collections, visit <a href=\"https://ulib.iupui.edu/collections\" target=\"_blank\" rel=\"noopener\">IUPUI University Library Digital Collections.</a></li>\r\n<li>To view digitized items with multiple pages, visit <a href=\"https://pages.dlib.indiana.edu/\" target=\"_blank\" rel=\"noopener\">Pages Online.</a></li>\r\n<li>To view digitized archival materials, visit <a href=\"http://www.dlib.indiana.edu/collections/findingaids\" target=\"_blank\" rel=\"noopener\">Legacy Archives Online.</a></li>\r\n<li>To view additional IUPUI collections, visit <a href=\"https://www.ulib.iupui.edu/special\" target=\"_blank\" rel=\"noopener\">Ruth Lilly Special Collections &amp\; Archives.</a></li>\r\n</ul>"
      cb.save!
    end
  end
  def down
    puts "No change on rollback."
  end
end
