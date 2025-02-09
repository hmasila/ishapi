#
# ishapi / newsitems / _index
#

puts! newsitems, 'newsitems idx'

json.n_newsitems newsitems.count
json.newsitems do
  json.array! newsitems do |item|
    json.name        item.name
    json.created_at  item.created_at
    json.updated_at  item.updated_at

    json.description item.description

    if item.gallery
      json.id           item.gallery_id.to_s
      json.item_type    item.gallery.class.name
      json.name         item.gallery.name
      json.slug  item.gallery.slug
      json.username     item.username || item.gallery.username || 'donor-default'
      json.n_photos     item.gallery.photos.length
      json.slug         item.gallery.slug
      json.subhead      item.gallery.subhead
      json.partial!    'ishapi/application/meta', :item => item.gallery
      if item.gallery.is_premium
        json.premium_tier item.gallery.premium_tier
        json.is_premium   item.gallery.premium_tier > 0
        json.is_purchased current_user&.profile&.has_premium_purchase( item.gallery )
        json.partial!    'ishapi/photos/index',     :photos => [ item.gallery.photos[0] ]
      else
        json.partial!    'ishapi/photos/index',     :photos => item.gallery.photos[0...3]
      end
    end

    if item.report
      if item.report.item_type == 'longscroll' # this allows you to have a wall of scrollable text instead of clickable items
        json.description item.report.descr

      else
        json.id         item.report_id.to_s
        json.item_type  item.report.class.name
        json.name       item.report.name
        json.reportname item.report.slug
        json.subhead    item.report.subhead
        json.username   item.report.user_profile.name if item.report.user_profile

        if item.report.photo
          json.photo_s169_url item.report.photo.photo.url( :s169 )
          json.photo_thumb2_url item.report.photo.photo.url( :thumb2 )
        end

        json.partial! 'ishapi/application/meta', :item => item.report

        if item.report.is_premium
          json.premium_tier item.report.premium_tier
          json.is_premium   item.report.premium_tier > 0
          json.is_purchased current_user&.profile&.has_premium_purchase( item.report )
        end
      end
    end

    if item.video_id
      json.id item.video_id.to_s
      # @TODO: why this relation is so weird here?!
      video = Video.unscoped.find( item.video_id )
      json.item_type video.class.name
      json.partial! 'ishapi/videos/show', :video => video
    end

    if item.photo
      json.id item.photo.id.to_s
      json.item_type item.photo.class.name
      json.partial! 'ishapi/photos/index', :photos => [ item.photo ]
    end

  end
end
