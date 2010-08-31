module Sequel
  module Plugins
    module Mappable

      def self.apply(model, opts={}, &block)
        model.send(:include, Geokit::Geocoders)
        model.send(:include, Geokit::Mappable)
      end

      def self.configure(model, opts={}, &block)
      end

      module ClassMethods
        def acts_as_mappable
          true
        end

        def distance_column_name
          :distance
        end

        def lat_column_name
          :lat
        end

        def lng_column_name
          :lng
        end

        def distance_sql(origin)
          lat = deg2rad(origin.lat)
          lng = deg2rad(origin.lng)
          multiplier = units_sphere_multiplier(:kms)
          %|
            (ACOS(least(1,COS(#{lat})*COS(#{lng})*COS(RADIANS(lat))*COS(RADIANS(lng))+
            COS(#{lat})*SIN(#{lng})*COS(RADIANS(lat))*SIN(RADIANS(lng))+
            SIN(#{lat})*SIN(RADIANS(lat))))*#{multiplier})
          |
        end
      end

      module InstanceMethods       
      end

      module DatasetMethods       
        def f_origin_bbox(origin, within)
          bounds = Geokit::Bounds.from_point_and_radius(origin, within, :units => :kms)
          sw, ne = bounds.sw, bounds.ne
          filter = self
          if bounds.crosses_meridian?
            filter = filter.filter{(lng < ne.lng) | (lng > sw.lng)}
          else
            filter = filter.filter{(lng < ne.lng) & (lng > sw.lng)}
          end
          filter.filter{(lat < ne.lat) & (lat > sw.lat)}
        end

        def f_origin(origin, within)
          sql = model.distance_sql(origin)
          f_origin_bbox(origin, within).filter{sql.lit <= within}
        end
      end
    end
  end
end

