module GSectionedShower
  module ViewHelpers
   
    # GUIlded component.
    #
    # *parameters*
    # ar_obj:: The ActiveRecord object containing the information.
    # 
    # *options*
    # id:: (required) The id of the element.  Must be unique on the page.
    # class::
    # title_attr:: The attribute to use in the title.
    # title_pre:: A string to override the first part of the title.  defaults to the name 
    #   of the active record object's class.
    # date_format:: A symbol representing the date format to use.  Defaults to :default.
    # attributes:: A list of attributes to include in the main section.
    # status:: True to include a status section.
    # namespace:: A namespace to append onto all path helpers that are not overridden.
    # sections::
    #   title:: The title for this section.
    #   attributes:: List of attibutes to include in this section.
    #   {associated_attribute_name}_attributes:: List of attributes from associated attribute to include.
    #   {associated_attribute_name}_max:: The max number of associated records to show.  This will load 
    #     all and display max unless you define a limited named scope on the respective model, allowing
    #     the association to be limited to the max, not returning items that will not be displayed.
    #   links:: A list of fields or field => path_helper to generate links to this item in the associated 
    #     object.
    #   list_link:: (Boolean, string, or symbol)
    #
    def g_sectioned_shower( ar_obj, *args )
      
      options = args.extract_options!
      raise ArgumentError, "'title_attr' option required" unless options.include?( :title_attr )
      raise ArgumentError, "'sections' option required" unless options.include?( :sections )
      options.merge! :class => "shower" unless options.include?( :class )
      options.merge! :exclude_css => true, :exclude_js => true 
      Guilded::Guilder.instance.add( :sectioned_shower, options )

      html = ""
      html << "<div class=\"status #{options[:status]}\">#{options[:status].to_s.humanize}</div>" if options[:status]
      
      title_pre = options[:title_pre] || "#{ar_obj.class.to_s.underscore.humanize} |"
      html << "<h2>#{title_pre} #{ar_obj.send( options[:title_attr].to_sym )}</h2>"
      
      # Resolve sections and meta data there-in
      sections = options[:sections]
      reflections = ar_obj.class.inheritable_attributes[:reflections]
      
      # Resolve main section
      main_section = sections[0]
      raise ArgumentError, "'attributes' option required within main section configuration" unless main_section.include?( :attributes )
      
      methods, titles = Guilded::Rails::Helpers.resolve_field_methods_and_titles( main_section[:attributes], ar_obj )
      
      html << "<div class=\"infoItem tableDisplay\"><dl>"
      
      methods.each_with_index do |method, i|
        
        # Handle associative relationships
        if !reflections.nil? && reflections.has_key?( method.to_sym )
          handle_associated( html, ar_obj, main_section, options, reflections, methods, i )
        else
          # Normal attribute from this model
          html << "<dt>#{titles[i]}</dt>"
          translate_method = "translate_#{method}".to_sym
          val = ar_obj.send( method )
          if respond_to?( translate_method )
            html << "<dd>#{h( send( translate_method, val ) )}</dd>"
          else
            val = val.to_formatted_s( options[:date_format] || :default ) if val.respond_to?( :to_formatted_s )
            html << "<dd>#{h( val )}</dd>"
          end
        end
        
      end
      
      html << "</dl><div class=\"clear\"></div></div>"

      # Get rid of the main section as it was already handled
      sections.delete_at( 0 )
      
      # Resolve other sections
      sections.each do |section|
        
        raise ArgumentError, "'attributes' option required within main section configuration" unless section.include?( :attributes )
        raise ArgumentError, "'title' option required within all section configurations except the main section" unless section.include?( :title )
        
        methods, titles = resolve_field_methods_and_titles( section[:attributes], ar_obj )
        html << "<div class=\"infoItem tableDisplay\"><h3>#{section[:title]}</h3><dl>"
        
        methods.each_with_index do |method, i|

          # Handle associative relationships
          if !reflections.nil? && reflections.has_key?( method.to_sym )
            handle_associated( html, ar_obj, section, options, reflections, methods, i )
          else
            # Normal attribute from this model
            html << "<dt>#{titles[i]}</dt>"
            translate_method = "translate_#{method}".to_sym
            val = ar_obj.send( method )
            if respond_to?( translate_method )
              "<dd>#{h( send( translate_method, val ) )}</dd>"
            else
              html << "<dd>#{h( val )}</dd>"
            end
          end

        end

        html << "</dl><div class=\"clear\"></div></div>"
        
      end
      
      html
      
    end
    
  private
    
    def handle_associated( html, ar_obj, section, options, reflections, methods, index )
      
      #TODO handle translation helpers if they exist.
      
      reflection = reflections[methods[index].to_sym]

      # Handle many relationships
      if ['has_many', 'has_and_belongs_to_many'].include?( reflection.macro.to_s )

        reflected_name = reflection.name.to_s
        reflected_singular_name = reflected_name.singularize
        reflected_humanized_name = reflected_name.humanize
        attrs_name = "#{reflected_singular_name}_attributes"
        attrs = section[ attrs_name.to_sym ]
        max_name = "#{reflected_singular_name}_max"
        max = section[ max_name.to_sym ]
        showing_less_than_all = max && max < ar_obj.send( methods[index] ).count
        empty_embedded_ar_obj = reflection.klass.new
        rel_methods, rel_titles = resolve_field_methods_and_titles( attrs, empty_embedded_ar_obj ) unless attrs.nil? || attrs.empty?
        
        # Handle creating a link to the associated many objects list
        if section[:list_link]
          
          if section[:list_link].is_a?( Symbol )
            assoc_obj_index_path_helper = section[:list_link].to_s
          elsif section[:list_link].is_a?( String )
            assoc_obj_index_path_helper = section[:list_link]
          elsif section[:list_link] == true
            non_namespaced_index_path_helper = "#{ar_obj.class.to_s.tableize.singularize}_#{reflection.name.to_s}_path"
            if options[:namespace]
              assoc_obj_index_path_helper = "#{options[:namespace].to_s}_#{non_namespaced_index_path_helper}"
            else
              assoc_obj_index_path_helper = non_namespaced_index_path_helper
            end
          else
            throw "The 'list_link' parameter must be a String, Symbol or true"
          end
          
          if showing_less_than_all
            index_link = link_to( "More #{reflected_humanized_name}...", @controller.send( assoc_obj_index_path_helper, ar_obj ) )
          else
            index_link = link_to( "Jump to #{reflected_humanized_name}", @controller.send( assoc_obj_index_path_helper, ar_obj ) )
          end
        
          html << "<dt>#{index_link}</dt><dd></dd>"
          
        end
        
        # Loop through the collection of embeddeds
        if max && ar_obj.send( methods[index] ).respond_to?( :limited )
          embedded_collection = ar_obj.send( methods[index] ).limited( max )
        else
          embedded_collection = ar_obj.send( methods[index] )
        end          
        
        embedded_collection.each_with_index do |assoc_ar_obj, i|

          break if max && i == max # Only display the max number specified (only necessary for when limited is not defined on AR class)
          
          assoc_obj_output = ""

          if section.has_key?( "#{reflected_singular_name}_attributes".to_sym )
            # Handle object output if fields specified explicitly
            
            rel_methods.each_with_index do |rel_method, rel_i|
              
              method_output = h( assoc_ar_obj.send( rel_method ) )
              
              if section.has_key?( :links )
                
                links = section[:links]
                throw "The 'links' option must have values in it, or be left out of the options for the section." if links.empty?
                link_entry = find_link_entry( links, rel_method )
                
                if link_entry.nil?
                  assoc_obj_output << "<dt>#{rel_titles[rel_i]}</dt><dd>#{h( method_output )}</dd>"
                elsif link_entry.is_a?( Symbol ) || link_entry.is_a?( String )
                  show_rest_method = "#{assoc_ar_obj.class.to_s.tableize.singularize}_path"
                  assoc_obj_link = @controller.send( show_rest_method, assoc_ar_obj )
                  assoc_obj_output << "<dt>#{rel_titles[rel_i]}</dt><dd>#{link_to( method_output, assoc_obj_link )}</dd>"
                elsif link_entry.is_a?( Hash )
                  show_rest_method = link_entry[rel_method.to_sym]
                  assoc_obj_link = @controller.send( show_rest_method, assoc_ar_obj )
                  assoc_obj_output << "<dt>#{rel_titles[rel_i]}</dt><dd>#{link_to( method_output, assoc_obj_link )}</dd>"
                else
                  assoc_obj_output << "<dt>#{rel_titles[rel_i]}</dt><dd>#{h( method_output )}</dd>"
                end
                
              else
                assoc_obj_output << "<dt>#{rel_titles[rel_i]}</dt><dd>#{h( method_output )}</dd>" #TODO can I resolve this repeating from 2 lines above?
              end
              
            end

          else
            # Otherwise just use to_s for the object
            assoc_obj_output << assoc_ar_obj.to_s
          end

          html << assoc_obj_output
          
        end
        
        # output '...' if there are embeddeds that are not displayed and we did not render a link to embeddeds index
        if showing_less_than_all && ( section[:list_link].nil? || section[:list_link] == false )
          html << "<dt>...</dt><dd></dd>"
        end

      elsif ['belongs_to', 'has_one'].include?( reflection.macro.to_s ) # Handle single relationships

        assoc_obj_output = ""

        if section.has_key?( "#{reflection.name.to_s.singularize}_attributes".to_sym )
          # Handle object output if fields specified explicitly

          attrs = section[ "#{reflection.name.to_s.singularize}_attributes".to_sym ]
          rel_methods, rel_titles = resolve_field_methods_and_titles( attrs, ar_obj.send( reflection.name.to_s.to_sym ) )
          assoc_obj = ar_obj.send( methods[index] )

          rel_methods.each_with_index do |rel_method, rel_i|
            
            method_output = h( assoc_obj.send( rel_method ) )
            
            if section.has_key?( :links )
                
              links = section[:links]
              throw "The 'links' option must have values in it, or be left out of the options for the section." if links.empty?
              link_entry = find_link_entry( links, rel_method )
              
              if link_entry.nil?
                assoc_obj_output << "<dt>#{rel_titles[rel_i]}</dt><dd>#{h( method_output )}</dd>"
              elsif link_entry.is_a?( Symbol ) || link_entry.is_a?( String )
                show_rest_method = "#{assoc_obj.class.to_s.tableize.singularize}_path"
                assoc_obj_link = @controller.send( show_rest_method, assoc_obj )
                assoc_obj_output << "<dt>#{rel_titles[rel_i]}</dt><dd>#{link_to( method_output, assoc_obj_link )}</dd>"
              elsif link_entry.is_a?( Hash )
                show_rest_method = link_entry[rel_method.to_sym]
                assoc_obj_link = @controller.send( show_rest_method, assoc_obj )
                assoc_obj_output << "<dt>#{rel_titles[rel_i]}</dt><dd>#{link_to( method_output, assoc_obj_link )}</dd>"
              else
                assoc_obj_output << "<dt>#{rel_titles[rel_i]}</dt><dd>#{h( method_output )}</dd>"
              end

            else
              assoc_obj_output << "<dt>#{rel_titles[rel_i]}</dt><dd>#{h( method_output )}</dd>"
            end
            
          end

        else
          # Otherwise just use to_s for the object
          assoc_obj_output = ar_obj.send( methods[index] ).to_s
        end

        html << assoc_obj_output

      end

    end
    
    def find_link_entry( links, val )
      links.each do |link|
        if link.is_a?( Hash )
          return link if link.has_key?( val.to_sym )
        else
          return link if link == val.to_sym
        end
      end
      return nil
    end

  end
end