module MetsStructure
  def structure
    structure_type('logical')
  end

  def structure_for_volume(volume_id)
    volume = volume_nodes.find { |vol| vol.attribute("ID").value == volume_id }
    { nodes: structure_for_nodeset(volume.element_children) }
  end

  def file_label(file_id)
    struct = structure_map('logical')
    node = struct.xpath(".//mets:fptr[@FILEID='#{file_id}']").first if struct
    (label_from_hierarchy(node.parent) if node) ||
      label_for_element(related_objects(file_id))
  end

  private

    def structure_map(type)
      @mets.xpath("/mets:mets/mets:structMap[@TYPE='#{type}']").first
    end

    def structure_type(type)
      return nil unless structure_map(type)
      top = structure_map(type).xpath("mets:div/mets:div")
      return nil if top.blank?
      { label: 'Logical', nodes: structure_for_nodeset(top) }
    end

    def structure_for_nodeset(nodeset)
      nodes = []
      nodeset.each do |node|
        nodes << structure_recurse(node)
      end
      nodes
    end

    def structure_recurse(node)
      children = node.element_children
      return single_file_object(node) if children.blank? && node.name == 'fptr'
      return single_file_object(children.first) if !section(node) &&
                                                   single_file(children)

      child_nodes = []
      if single_file(children)
        child_nodes = [single_file_object(children.first)]
      else
        children.each do |child|
          child_nodes << structure_recurse(child)
        end
      end
      { label: label_for_element(node), nodes: child_nodes }
    end

    def section(node)
      node.attributes["TYPE"].try(:value) == "archivalitem"
    end

    def single_file(nodeset)
      nodeset.length == 1 && nodeset.first.name == 'fptr'
    end

    def single_file_object(node)
      id = node['FILEID']
      label = label_from_hierarchy(node.parent) ||
              label_for_element(related_objects(id))
      { label: label, proxy: id }
    end

    def label_from_hierarchy(node)
      current = node
      label = label_for_element(current)
      return nil unless label.present?
      while in_scope(current.parent) && (parent_label = label_for_element(current.parent))
        label = "#{parent_label}. #{label}"
        current = current.parent
      end
      label = '' if label&.gsub('. ').blank?
      label
    end

    def in_scope(node)
      if multi_volume?
        node.parent.parent.name == 'div'
      else
        node.parent.name == 'div'
      end
    end

    def related_objects(id)
      @mets.xpath("/mets:mets/mets:structMap[@TYPE='RelatedObjects']" \
                  "//mets:div[mets:fptr/@FILEID='#{id}']")
    end

    def label_for_element(node)
      return '' unless node.present?
      debugger if node.class != Nokogiri::XML::Element
      node_id = node["LABEL"]
      node_id = node['ID'] if node_id.blank?
      node_id = "#{node["TYPE"]} #{node['ORDER']}" if node_id.blank? &&
                                                      node['TYPE'].present?
      node_id = '' if node_id&.gsub(' ','').blank?
      node_id
    end
end
