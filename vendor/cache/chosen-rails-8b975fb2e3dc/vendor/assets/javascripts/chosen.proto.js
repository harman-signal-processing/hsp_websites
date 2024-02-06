(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  this.Chosen = (function(superClass) {
    var triggerHtmlEvent;

    extend(Chosen, superClass);

    function Chosen() {
      return Chosen.__super__.constructor.apply(this, arguments);
    }

    Chosen.prototype.setup = function() {
      return this.current_selectedIndex = this.form_field.selectedIndex;
    };

    Chosen.prototype.set_up_html = function() {
      var container_classes, container_props;
      container_classes = ["chosen-container"];
      container_classes.push("chosen-container-" + (this.is_multiple ? "multi" : "single"));
      if (this.inherit_select_classes && this.form_field.className) {
        container_classes.push(this.form_field.className);
      }
      if (this.is_rtl) {
        container_classes.push("chosen-rtl");
      }
      container_props = {
        'class': container_classes.join(' '),
        'title': this.form_field.title
      };
      if (this.form_field.id.length) {
        container_props.id = this.form_field.id.replace(/[^\w]/g, '_') + "_chosen";
      }
      this.container = new Element('div', container_props);
      this.container.setStyle({
        width: this.container_width()
      });
      if (this.is_multiple) {
        this.container.update(this.get_multi_html());
      } else {
        this.container.update(this.get_single_html());
      }
      this.form_field.hide().insert({
        after: this.container
      });
      this.dropdown = this.container.down('div.chosen-drop');
      this.search_field = this.container.down('input');
      this.search_results = this.container.down('ul.chosen-results');
      this.search_field_scale();
      this.search_no_results = this.container.down('li.no-results');
      if (this.is_multiple) {
        this.search_choices = this.container.down('ul.chosen-choices');
        this.search_container = this.container.down('li.search-field');
      } else {
        this.search_container = this.container.down('div.chosen-search');
        this.selected_item = this.container.down('.chosen-single');
      }
      this.results_build();
      this.set_tab_index();
      return this.set_label_behavior();
    };

    Chosen.prototype.on_ready = function() {
      return this.form_field.fire("chosen:ready", {
        chosen: this
      });
    };

    Chosen.prototype.register_observers = function() {
      this.container.observe("touchstart", (function(_this) {
        return function(evt) {
          return _this.container_mousedown(evt);
        };
      })(this));
      this.container.observe("touchend", (function(_this) {
        return function(evt) {
          return _this.container_mouseup(evt);
        };
      })(this));
      this.container.observe("mousedown", (function(_this) {
        return function(evt) {
          return _this.container_mousedown(evt);
        };
      })(this));
      this.container.observe("mouseup", (function(_this) {
        return function(evt) {
          return _this.container_mouseup(evt);
        };
      })(this));
      this.container.observe("mouseenter", (function(_this) {
        return function(evt) {
          return _this.mouse_enter(evt);
        };
      })(this));
      this.container.observe("mouseleave", (function(_this) {
        return function(evt) {
          return _this.mouse_leave(evt);
        };
      })(this));
      this.search_results.observe("mouseup", (function(_this) {
        return function(evt) {
          return _this.search_results_mouseup(evt);
        };
      })(this));
      this.search_results.observe("mouseover", (function(_this) {
        return function(evt) {
          return _this.search_results_mouseover(evt);
        };
      })(this));
      this.search_results.observe("mouseout", (function(_this) {
        return function(evt) {
          return _this.search_results_mouseout(evt);
        };
      })(this));
      this.search_results.observe("mousewheel", (function(_this) {
        return function(evt) {
          return _this.search_results_mousewheel(evt);
        };
      })(this));
      this.search_results.observe("DOMMouseScroll", (function(_this) {
        return function(evt) {
          return _this.search_results_mousewheel(evt);
        };
      })(this));
      this.search_results.observe("touchstart", (function(_this) {
        return function(evt) {
          return _this.search_results_touchstart(evt);
        };
      })(this));
      this.search_results.observe("touchmove", (function(_this) {
        return function(evt) {
          return _this.search_results_touchmove(evt);
        };
      })(this));
      this.search_results.observe("touchend", (function(_this) {
        return function(evt) {
          return _this.search_results_touchend(evt);
        };
      })(this));
      this.form_field.observe("chosen:updated", (function(_this) {
        return function(evt) {
          return _this.results_update_field(evt);
        };
      })(this));
      this.form_field.observe("chosen:activate", (function(_this) {
        return function(evt) {
          return _this.activate_field(evt);
        };
      })(this));
      this.form_field.observe("chosen:open", (function(_this) {
        return function(evt) {
          return _this.container_mousedown(evt);
        };
      })(this));
      this.form_field.observe("chosen:close", (function(_this) {
        return function(evt) {
          return _this.close_field(evt);
        };
      })(this));
      this.search_field.observe("blur", (function(_this) {
        return function(evt) {
          return _this.input_blur(evt);
        };
      })(this));
      this.search_field.observe("keyup", (function(_this) {
        return function(evt) {
          return _this.keyup_checker(evt);
        };
      })(this));
      this.search_field.observe("keydown", (function(_this) {
        return function(evt) {
          return _this.keydown_checker(evt);
        };
      })(this));
      this.search_field.observe("focus", (function(_this) {
        return function(evt) {
          return _this.input_focus(evt);
        };
      })(this));
      this.search_field.observe("cut", (function(_this) {
        return function(evt) {
          return _this.clipboard_event_checker(evt);
        };
      })(this));
      this.search_field.observe("paste", (function(_this) {
        return function(evt) {
          return _this.clipboard_event_checker(evt);
        };
      })(this));
      if (this.is_multiple) {
        return this.search_choices.observe("click", (function(_this) {
          return function(evt) {
            return _this.choices_click(evt);
          };
        })(this));
      } else {
        return this.container.observe("click", (function(_this) {
          return function(evt) {
            return evt.preventDefault();
          };
        })(this));
      }
    };

    Chosen.prototype.destroy = function() {
      var event, i, len, ref;
      this.container.ownerDocument.stopObserving("click", this.click_test_action);
      ref = ['chosen:updated', 'chosen:activate', 'chosen:open', 'chosen:close'];
      for (i = 0, len = ref.length; i < len; i++) {
        event = ref[i];
        this.form_field.stopObserving(event);
      }
      this.container.stopObserving();
      this.search_results.stopObserving();
      this.search_field.stopObserving();
      if (this.form_field_label != null) {
        this.form_field_label.stopObserving();
      }
      if (this.is_multiple) {
        this.search_choices.stopObserving();
        this.container.select(".search-choice-close").each(function(choice) {
          return choice.stopObserving();
        });
      } else {
        this.selected_item.stopObserving();
      }
      if (this.search_field.tabIndex) {
        this.form_field.tabIndex = this.search_field.tabIndex;
      }
      this.container.remove();
      return this.form_field.show();
    };

    Chosen.prototype.search_field_disabled = function() {
      var ref;
      this.is_disabled = this.form_field.disabled || ((ref = this.form_field.up('fieldset')) != null ? ref.disabled : void 0) || false;
      if (this.is_disabled) {
        this.container.addClassName('chosen-disabled');
      } else {
        this.container.removeClassName('chosen-disabled');
      }
      this.search_field.disabled = this.is_disabled;
      if (!this.is_multiple) {
        this.selected_item.stopObserving('focus', this.activate_field);
      }
      if (this.is_disabled) {
        return this.close_field();
      } else if (!this.is_multiple) {
        return this.selected_item.observe('focus', this.activate_field);
      }
    };

    Chosen.prototype.container_mousedown = function(evt) {
      var ref;
      if (this.is_disabled) {
        return;
      }
      if (evt && ((ref = evt.type) === 'mousedown' || ref === 'touchstart') && !this.results_showing) {
        evt.preventDefault();
      }
      if (!((evt != null) && evt.target.hasClassName("search-choice-close"))) {
        if (!this.active_field) {
          if (this.is_multiple) {
            this.search_field.clear();
          }
          this.container.ownerDocument.observe("click", this.click_test_action);
          this.results_show();
        } else if (!this.is_multiple && evt && (evt.target === this.selected_item || evt.target.up("a.chosen-single"))) {
          this.results_toggle();
        }
        return this.activate_field();
      }
    };

    Chosen.prototype.container_mouseup = function(evt) {
      if (evt.target.nodeName === "ABBR" && !this.is_disabled) {
        return this.results_reset(evt);
      }
    };

    Chosen.prototype.search_results_mousewheel = function(evt) {
      var delta;
      delta = evt.deltaY || -evt.wheelDelta || evt.detail;
      if (delta != null) {
        evt.preventDefault();
        if (evt.type === 'DOMMouseScroll') {
          delta = delta * 40;
        }
        return this.search_results.scrollTop = delta + this.search_results.scrollTop;
      }
    };

    Chosen.prototype.blur_test = function(evt) {
      if (!this.active_field && this.container.hasClassName("chosen-container-active")) {
        return this.close_field();
      }
    };

    Chosen.prototype.close_field = function() {
      this.container.ownerDocument.stopObserving("click", this.click_test_action);
      this.active_field = false;
      this.results_hide();
      this.container.removeClassName("chosen-container-active");
      this.clear_backstroke();
      this.show_search_field_default();
      this.search_field_scale();
      return this.search_field.blur();
    };

    Chosen.prototype.activate_field = function() {
      if (this.is_disabled) {
        return;
      }
      this.container.addClassName("chosen-container-active");
      this.active_field = true;
      this.search_field.value = this.get_search_field_value();
      return this.search_field.focus();
    };

    Chosen.prototype.test_active_click = function(evt) {
      if (evt.target.up('.chosen-container') === this.container) {
        return this.active_field = true;
      } else {
        return this.close_field();
      }
    };

    Chosen.prototype.results_build = function() {
      this.parsing = true;
      this.selected_option_count = null;
      this.results_data = SelectParser.select_to_array(this.form_field);
      if (this.is_multiple) {
        this.search_choices.select("li.search-choice").invoke("remove");
      } else {
        this.single_set_selected_text();
        if (this.disable_search || this.form_field.options.length <= this.disable_search_threshold) {
          this.search_field.readOnly = true;
          this.container.addClassName("chosen-container-single-nosearch");
        } else {
          this.search_field.readOnly = false;
          this.container.removeClassName("chosen-container-single-nosearch");
        }
      }
      this.update_results_content(this.results_option_build({
        first: true
      }));
      this.search_field_disabled();
      this.show_search_field_default();
      this.search_field_scale();
      return this.parsing = false;
    };

    Chosen.prototype.result_do_highlight = function(el) {
      var high_bottom, high_top, maxHeight, visible_bottom, visible_top;
      this.result_clear_highlight();
      this.result_highlight = el;
      this.result_highlight.addClassName("highlighted");
      maxHeight = parseInt(this.search_results.getStyle('maxHeight'), 10);
      visible_top = this.search_results.scrollTop;
      visible_bottom = maxHeight + visible_top;
      high_top = this.result_highlight.positionedOffset().top;
      high_bottom = high_top + this.result_highlight.getHeight();
      if (high_bottom >= visible_bottom) {
        return this.search_results.scrollTop = (high_bottom - maxHeight) > 0 ? high_bottom - maxHeight : 0;
      } else if (high_top < visible_top) {
        return this.search_results.scrollTop = high_top;
      }
    };

    Chosen.prototype.result_clear_highlight = function() {
      if (this.result_highlight) {
        this.result_highlight.removeClassName('highlighted');
      }
      return this.result_highlight = null;
    };

    Chosen.prototype.results_show = function() {
      if (this.is_multiple && this.max_selected_options <= this.choices_count()) {
        this.form_field.fire("chosen:maxselected", {
          chosen: this
        });
        return false;
      }
      this.container.addClassName("chosen-with-drop");
      this.results_showing = true;
      this.search_field.focus();
      this.search_field.value = this.get_search_field_value();
      this.winnow_results();
      return this.form_field.fire("chosen:showing_dropdown", {
        chosen: this
      });
    };

    Chosen.prototype.update_results_content = function(content) {
      return this.search_results.update(content);
    };

    Chosen.prototype.results_hide = function() {
      if (this.results_showing) {
        this.result_clear_highlight();
        this.container.removeClassName("chosen-with-drop");
        this.form_field.fire("chosen:hiding_dropdown", {
          chosen: this
        });
      }
      return this.results_showing = false;
    };

    Chosen.prototype.set_tab_index = function(el) {
      var ti;
      if (this.form_field.tabIndex) {
        ti = this.form_field.tabIndex;
        this.form_field.tabIndex = -1;
        return this.search_field.tabIndex = ti;
      }
    };

    Chosen.prototype.set_label_behavior = function() {
      this.form_field_label = this.form_field.up("label");
      if (this.form_field_label == null) {
        this.form_field_label = $$("label[for='" + this.form_field.id + "']").first();
      }
      if (this.form_field_label != null) {
        return this.form_field_label.observe("click", this.label_click_handler);
      }
    };

    Chosen.prototype.show_search_field_default = function() {
      if (this.is_multiple && this.choices_count() < 1 && !this.active_field) {
        this.search_field.value = this.default_text;
        return this.search_field.addClassName("default");
      } else {
        this.search_field.value = "";
        return this.search_field.removeClassName("default");
      }
    };

    Chosen.prototype.search_results_mouseup = function(evt) {
      var target;
      target = evt.target.hasClassName("active-result") ? evt.target : evt.target.up(".active-result");
      if (target) {
        this.result_highlight = target;
        this.result_select(evt);
        return this.search_field.focus();
      }
    };

    Chosen.prototype.search_results_mouseover = function(evt) {
      var target;
      target = evt.target.hasClassName("active-result") ? evt.target : evt.target.up(".active-result");
      if (target) {
        return this.result_do_highlight(target);
      }
    };

    Chosen.prototype.search_results_mouseout = function(evt) {
      if (evt.target.hasClassName('active-result') || evt.target.up('.active-result')) {
        return this.result_clear_highlight();
      }
    };

    Chosen.prototype.choice_build = function(item) {
      var choice, close_link;
      choice = new Element('li', {
        "class": "search-choice"
      }).update("<span>" + (this.choice_label(item)) + "</span>");
      if (item.disabled) {
        choice.addClassName('search-choice-disabled');
      } else {
        close_link = new Element('a', {
          href: '#',
          "class": 'search-choice-close',
          rel: item.array_index
        });
        close_link.observe("click", (function(_this) {
          return function(evt) {
            return _this.choice_destroy_link_click(evt);
          };
        })(this));
        choice.insert(close_link);
      }
      return this.search_container.insert({
        before: choice
      });
    };

    Chosen.prototype.choice_destroy_link_click = function(evt) {
      evt.preventDefault();
      evt.stopPropagation();
      if (!this.is_disabled) {
        return this.choice_destroy(evt.target);
      }
    };

    Chosen.prototype.choice_destroy = function(link) {
      if (this.result_deselect(link.readAttribute("rel"))) {
        if (this.active_field) {
          this.search_field.focus();
        } else {
          this.show_search_field_default();
        }
        if (this.is_multiple && this.choices_count() > 0 && this.get_search_field_value().length < 1) {
          this.results_hide();
        }
        link.up('li').remove();
        return this.search_field_scale();
      }
    };

    Chosen.prototype.results_reset = function() {
      this.reset_single_select_options();
      this.form_field.options[0].selected = true;
      this.single_set_selected_text();
      this.show_search_field_default();
      this.results_reset_cleanup();
      this.trigger_form_field_change();
      if (this.active_field) {
        return this.results_hide();
      }
    };

    Chosen.prototype.results_reset_cleanup = function() {
      var deselect_trigger;
      this.current_selectedIndex = this.form_field.selectedIndex;
      deselect_trigger = this.selected_item.down("abbr");
      if (deselect_trigger) {
        return deselect_trigger.remove();
      }
    };

    Chosen.prototype.result_select = function(evt) {
      var high, item;
      if (this.result_highlight) {
        high = this.result_highlight;
        this.result_clear_highlight();
        if (this.is_multiple && this.max_selected_options <= this.choices_count()) {
          this.form_field.fire("chosen:maxselected", {
            chosen: this
          });
          return false;
        }
        if (this.is_multiple) {
          high.removeClassName("active-result");
        } else {
          this.reset_single_select_options();
        }
        high.addClassName("result-selected");
        item = this.results_data[high.getAttribute("data-option-array-index")];
        item.selected = true;
        this.form_field.options[item.options_index].selected = true;
        this.selected_option_count = null;
        if (this.is_multiple) {
          this.choice_build(item);
        } else {
          this.single_set_selected_text(this.choice_label(item));
        }
        if (this.is_multiple && (!this.hide_results_on_select || (evt.metaKey || evt.ctrlKey))) {
          if (evt.metaKey || evt.ctrlKey) {
            this.winnow_results({
              skip_highlight: true
            });
          } else {
            this.search_field.value = "";
            this.winnow_results();
          }
        } else {
          this.results_hide();
          this.show_search_field_default();
        }
        if (this.is_multiple || this.form_field.selectedIndex !== this.current_selectedIndex) {
          this.trigger_form_field_change();
        }
        this.current_selectedIndex = this.form_field.selectedIndex;
        evt.preventDefault();
        return this.search_field_scale();
      }
    };

    Chosen.prototype.single_set_selected_text = function(text) {
      if (text == null) {
        text = this.default_text;
      }
      if (text === this.default_text) {
        this.selected_item.addClassName("chosen-default");
      } else {
        this.single_deselect_control_build();
        this.selected_item.removeClassName("chosen-default");
      }
      return this.selected_item.down("span").update(text);
    };

    Chosen.prototype.result_deselect = function(pos) {
      var result_data;
      result_data = this.results_data[pos];
      if (!this.form_field.options[result_data.options_index].disabled) {
        result_data.selected = false;
        this.form_field.options[result_data.options_index].selected = false;
        this.selected_option_count = null;
        this.result_clear_highlight();
        if (this.results_showing) {
          this.winnow_results();
        }
        this.trigger_form_field_change();
        this.search_field_scale();
        return true;
      } else {
        return false;
      }
    };

    Chosen.prototype.single_deselect_control_build = function() {
      if (!this.allow_single_deselect) {
        return;
      }
      if (!this.selected_item.down("abbr")) {
        this.selected_item.down("span").insert({
          after: "<abbr class=\"search-choice-close\"></abbr>"
        });
      }
      return this.selected_item.addClassName("chosen-single-with-deselect");
    };

    Chosen.prototype.get_search_field_value = function() {
      return this.search_field.value;
    };

    Chosen.prototype.get_search_text = function() {
      return this.get_search_field_value().strip();
    };

    Chosen.prototype.escape_html = function(text) {
      return text.escapeHTML();
    };

    Chosen.prototype.winnow_results_set_highlight = function() {
      var do_high;
      if (!this.is_multiple) {
        do_high = this.search_results.down(".result-selected.active-result");
      }
      if (do_high == null) {
        do_high = this.search_results.down(".active-result");
      }
      if (do_high != null) {
        return this.result_do_highlight(do_high);
      }
    };

    Chosen.prototype.no_results = function(terms) {
      this.search_results.insert(this.get_no_results_html(terms));
      return this.form_field.fire("chosen:no_results", {
        chosen: this
      });
    };

    Chosen.prototype.no_results_clear = function() {
      var nr, results;
      nr = null;
      results = [];
      while (nr = this.search_results.down(".no-results")) {
        results.push(nr.remove());
      }
      return results;
    };

    Chosen.prototype.keydown_arrow = function() {
      var next_sib;
      if (this.results_showing && this.result_highlight) {
        next_sib = this.result_highlight.next('.active-result');
        if (next_sib) {
          return this.result_do_highlight(next_sib);
        }
      } else {
        return this.results_show();
      }
    };

    Chosen.prototype.keyup_arrow = function() {
      var actives, prevs, sibs;
      if (!this.results_showing && !this.is_multiple) {
        return this.results_show();
      } else if (this.result_highlight) {
        sibs = this.result_highlight.previousSiblings();
        actives = this.search_results.select("li.active-result");
        prevs = sibs.intersect(actives);
        if (prevs.length) {
          return this.result_do_highlight(prevs.first());
        } else {
          if (this.choices_count() > 0) {
            this.results_hide();
          }
          return this.result_clear_highlight();
        }
      }
    };

    Chosen.prototype.keydown_backstroke = function() {
      var next_available_destroy;
      if (this.pending_backstroke) {
        this.choice_destroy(this.pending_backstroke.down("a"));
        return this.clear_backstroke();
      } else {
        next_available_destroy = this.search_container.siblings().last();
        if (next_available_destroy && next_available_destroy.hasClassName("search-choice") && !next_available_destroy.hasClassName("search-choice-disabled")) {
          this.pending_backstroke = next_available_destroy;
          if (this.pending_backstroke) {
            this.pending_backstroke.addClassName("search-choice-focus");
          }
          if (this.single_backstroke_delete) {
            return this.keydown_backstroke();
          } else {
            return this.pending_backstroke.addClassName("search-choice-focus");
          }
        }
      }
    };

    Chosen.prototype.clear_backstroke = function() {
      if (this.pending_backstroke) {
        this.pending_backstroke.removeClassName("search-choice-focus");
      }
      return this.pending_backstroke = null;
    };

    Chosen.prototype.search_field_scale = function() {
      var container_width, div, i, len, style, style_block, styles, width;
      if (!this.is_multiple) {
        return;
      }
      style_block = {
        position: 'absolute',
        left: '-1000px',
        top: '-1000px',
        display: 'none',
        whiteSpace: 'pre'
      };
      styles = ['fontSize', 'fontStyle', 'fontWeight', 'fontFamily', 'lineHeight', 'textTransform', 'letterSpacing'];
      for (i = 0, len = styles.length; i < len; i++) {
        style = styles[i];
        style_block[style] = this.search_field.getStyle(style);
      }
      div = new Element('div').update(this.escape_html(this.get_search_field_value()));
      div.setStyle(style_block);
      document.body.appendChild(div);
      width = div.measure('width') + 25;
      div.remove();
      if (container_width = this.container.getWidth()) {
        width = Math.min(container_width - 10, width);
      }
      return this.search_field.setStyle({
        width: width + 'px'
      });
    };

    Chosen.prototype.trigger_form_field_change = function() {
      triggerHtmlEvent(this.form_field, 'input');
      return triggerHtmlEvent(this.form_field, 'change');
    };

    triggerHtmlEvent = function(element, eventType) {
      var evt;
      if (element.dispatchEvent) {
        try {
          evt = new Event(eventType, {
            bubbles: true,
            cancelable: true
          });
        } catch (error) {
          evt = document.createEvent('HTMLEvents');
          evt.initEvent(eventType, true, true);
        }
        return element.dispatchEvent(evt);
      } else {
        return element.fireEvent("on" + eventType, document.createEventObject());
      }
    };

    return Chosen;

  })(AbstractChosen);

}).call(this);
