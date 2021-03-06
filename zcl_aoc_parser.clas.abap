class ZCL_AOC_PARSER definition
  public
  final
  create public .

public section.
*"* public components of class ZCL_AOC_PARSER
*"* do not include other source files here!!!

  types:
    BEGIN OF st_token,
               type     TYPE c LENGTH 1,
               value    TYPE string,
               code     TYPE string,
               rulename TYPE string,
             END OF st_token .
  types:
    tt_tokens TYPE STANDARD TABLE OF st_token WITH NON-UNIQUE DEFAULT KEY .
  types:
    BEGIN OF st_result,
               match TYPE abap_bool,
               tokens TYPE tt_tokens,
             END OF st_result .

  constants C_ROLE type C value 'R'. "#EC NOTEXT
  constants C_TERMINAL type C value 'T'. "#EC NOTEXT
  constants C_ROLE_FIELDDEFID type STRING value 'FieldDefId'. "#EC NOTEXT

  type-pools ABAP .
  class ZCL_AOC_PARSER definition load .
  class-methods RUN
    importing
      !IT_CODE type STRING_TABLE
      !IV_DEBUG type ABAP_BOOL default ABAP_FALSE
      !IV_RULE type STRING default 'START'
      !IV_ALLOW_OBSOLETE type ABAP_BOOL default ABAP_TRUE
    returning
      value(RS_RESULT) type ZCL_AOC_PARSER=>ST_RESULT .
protected section.
*"* protected components of class ZCL_AOC_PARSER
*"* do not include other source files here!!!

  class-methods XML_FIX
    changing
      !CV_XML type STRING .
  class-methods BUILD_PERMUTATION
    importing
      !II_RULE type ref to IF_IXML_NODE
      !IV_RULENAME type STRING
      !IO_BEFORE type ref to LCL_NODE
      !IO_AFTER type ref to LCL_NODE .
  class-methods BUILD_OPTIONLIST
    importing
      !II_RULE type ref to IF_IXML_NODE
      !IV_RULENAME type STRING
      !IO_BEFORE type ref to LCL_NODE
      !IO_AFTER type ref to LCL_NODE .
  class-methods BUILD_OPTION
    importing
      !II_RULE type ref to IF_IXML_NODE
      !IV_RULENAME type STRING
      !IO_BEFORE type ref to LCL_NODE
      !IO_AFTER type ref to LCL_NODE .
  class-methods BUILD_NONTERMINAL
    importing
      !II_RULE type ref to IF_IXML_NODE
      !IV_RULENAME type STRING
      !IO_BEFORE type ref to LCL_NODE
      !IO_AFTER type ref to LCL_NODE .
  class-methods BUILD_ITERATION
    importing
      !II_RULE type ref to IF_IXML_NODE
      !IV_RULENAME type STRING
      !IO_BEFORE type ref to LCL_NODE
      !IO_AFTER type ref to LCL_NODE .
  class-methods BUILD_ALTERNATIVE
    importing
      !II_RULE type ref to IF_IXML_NODE
      !IV_RULENAME type STRING
      !IO_BEFORE type ref to LCL_NODE
      !IO_AFTER type ref to LCL_NODE .
  class-methods BUILD
    importing
      !II_RULE type ref to IF_IXML_NODE
      !IV_RULENAME type STRING
      !IO_BEFORE type ref to LCL_NODE
      !IO_AFTER type ref to LCL_NODE .
  class-methods GRAPH_BUILD
    importing
      !IV_RULENAME type STRING
    exporting
      !EO_START type ref to LCL_NODE
      !EO_END type ref to LCL_NODE .
  class-methods GRAPH_DOWNLOAD
    importing
      !IV_RULENAME type STRING
      !IO_START type ref to LCL_NODE .
  class-methods GRAPH_TO_TEXT
    importing
      !IO_NODE type ref to LCL_NODE
    returning
      value(RV_TEXT) type STRING .
  class ZCL_AOC_PARSER definition load .
  class-methods WALK
    importing
      !IO_NODE type ref to LCL_NODE
      !IV_INDEX type I
    returning
      value(RS_RESULT) type ZCL_AOC_PARSER=>ST_RESULT .
  class-methods XML_DOWNLOAD
    importing
      !IV_RULENAME type STRING
      !II_XML type ref to IF_IXML
      !II_XML_DOC type ref to IF_IXML_DOCUMENT .
  class-methods BUILD_ROLE
    importing
      !II_RULE type ref to IF_IXML_NODE
      !IV_RULENAME type STRING
      !IO_BEFORE type ref to LCL_NODE
      !IO_AFTER type ref to LCL_NODE .
  class-methods BUILD_SEQUENCE
    importing
      !II_RULE type ref to IF_IXML_NODE
      !IV_RULENAME type STRING
      !IO_BEFORE type ref to LCL_NODE
      !IO_AFTER type ref to LCL_NODE .
  class-methods BUILD_TERMINAL
    importing
      !II_RULE type ref to IF_IXML_NODE
      !IV_RULENAME type STRING
      !IO_BEFORE type ref to LCL_NODE
      !IO_AFTER type ref to LCL_NODE .
  class-methods WALK_TERMINAL
    importing
      !IO_NODE type ref to LCL_NODE
      !IV_INDEX type I
    returning
      value(RS_RESULT) type ZCL_AOC_PARSER=>ST_RESULT .
  class-methods WALK_ROLE
    importing
      !IO_NODE type ref to LCL_NODE
      !IV_INDEX type I
    returning
      value(RS_RESULT) type ZCL_AOC_PARSER=>ST_RESULT .
  class-methods WALK_NONTERMINAL
    importing
      !IO_NODE type ref to LCL_NODE
      !IV_INDEX type I
    returning
      value(RS_RESULT) type ZCL_AOC_PARSER=>ST_RESULT .
  class-methods WALK_NODE
    importing
      !IO_NODE type ref to LCL_NODE
      !IV_INDEX type I
    returning
      value(RS_RESULT) type ZCL_AOC_PARSER=>ST_RESULT .
  class-methods WALK_END
    importing
      !IO_NODE type ref to LCL_NODE
      !IV_INDEX type I
    returning
      value(RS_RESULT) type ZCL_AOC_PARSER=>ST_RESULT .
  class-methods XML_GET
    importing
      !IV_RULENAME type STRING
    returning
      value(RI_RULE) type ref to IF_IXML_NODE .
  class-methods XML_PARSE
    importing
      !IV_RULENAME type STRING
      !IV_XML type STRING
    returning
      value(RI_RULE) type ref to IF_IXML_NODE .
  class-methods PARSE
    importing
      !IT_TOKENS type STOKESX_TAB
      !IT_STATEMENTS type SSTMNT_TAB
    returning
      value(RS_RESULT) type ZCL_AOC_PARSER=>ST_RESULT .
private section.
*"* private components of class ZCL_AOC_PARSER
*"* do not include other source files here!!!

  class-data GT_TOKENS type STRING_TABLE .
  class-data GV_END_RULE type STRING .
  type-pools ABAP .
  class-data GV_DEBUG type ABAP_BOOL .
  class-data GV_ALLOW_OBSOLETE type ABAP_BOOL .
ENDCLASS.



CLASS ZCL_AOC_PARSER IMPLEMENTATION.


METHOD build.

  DATA: lv_name TYPE string.


  IF NOT ii_rule IS BOUND.
    io_before->edge( io_after ).
    RETURN.
  ENDIF.

  lv_name = ii_rule->get_name( ).

* todo, change input to structure instead?

  CASE lv_name.
    WHEN 'Sequence'.
      build_sequence(
          ii_rule   = ii_rule
          iv_rulename = iv_rulename
          io_before = io_before
          io_after  = io_after ).
    WHEN 'Alternative'.
      build_alternative(
          ii_rule   = ii_rule
          iv_rulename = iv_rulename
          io_before = io_before
          io_after  = io_after ).
    WHEN 'Nonterminal'.
      build_nonterminal(
          ii_rule   = ii_rule
          iv_rulename = iv_rulename
          io_before = io_before
          io_after  = io_after ).
    WHEN 'Terminal'.
      build_terminal(
          ii_rule   = ii_rule
          iv_rulename = iv_rulename
          io_before = io_before
          io_after  = io_after ).
    WHEN 'Role'.
      build_role(
          ii_rule   = ii_rule
          iv_rulename = iv_rulename
          io_before = io_before
          io_after  = io_after ).
    WHEN 'Option'.
      build_option(
          ii_rule   = ii_rule
          iv_rulename = iv_rulename
          io_before = io_before
          io_after  = io_after ).
    WHEN 'Permutation'.
      build_permutation(
          ii_rule   = ii_rule
          iv_rulename = iv_rulename
          io_before = io_before
          io_after  = io_after ).
    WHEN 'Iteration'.
      build_iteration(
          ii_rule   = ii_rule
          iv_rulename = iv_rulename
          io_before = io_before
          io_after  = io_after ).
    WHEN 'Optionlist'.
      build_optionlist(
          ii_rule   = ii_rule
          iv_rulename = iv_rulename
          io_before = io_before
          io_after  = io_after ).
  ENDCASE.

ENDMETHOD.


METHOD build_alternative.

  DATA: li_children TYPE REF TO if_ixml_node_list,
        lo_dummy    TYPE REF TO lcl_node,
        li_child    TYPE REF TO if_ixml_node.


  CREATE OBJECT lo_dummy
    EXPORTING
      iv_type     = gc_dummy
      iv_value    = 'Alternative'
      iv_rulename = iv_rulename.                            "#EC NOTEXT

  li_children = ii_rule->get_children( ).

  io_before->edge( lo_dummy ).

  DO li_children->get_length( ) TIMES.
    li_child = li_children->get_item( sy-index - 1 ).
    li_child = li_child->get_first_child( ). " get rid of <Alt> tag
    build( ii_rule   = li_child
           iv_rulename = iv_rulename
           io_before = lo_dummy
           io_after  = io_after ).
  ENDDO.

ENDMETHOD.


METHOD build_iteration.

  DATA: li_child  TYPE REF TO if_ixml_node,
        lo_dummy1 TYPE REF TO lcl_node,
        lo_dummy2 TYPE REF TO lcl_node.


  li_child = ii_rule->get_first_child( ).

  CREATE OBJECT lo_dummy1
    EXPORTING
      iv_type     = gc_dummy
      iv_value    = 'IterationStart'
      iv_rulename = iv_rulename.                            "#EC NOTEXT

  CREATE OBJECT lo_dummy2
    EXPORTING
      iv_type     = gc_dummy
      iv_value    = 'IterationEnd'
      iv_rulename = iv_rulename.                            "#EC NOTEXT

  io_before->edge( lo_dummy1 ).
  lo_dummy2->edge( io_after ).
  lo_dummy2->edge( lo_dummy1 ).

  build( ii_rule   = li_child
         iv_rulename = iv_rulename
         io_before = lo_dummy1
         io_after  = lo_dummy2 ).

ENDMETHOD.


METHOD build_nonterminal.

  DATA: lv_rulename TYPE string,
        lo_node     TYPE REF TO lcl_node.


  lv_rulename = ii_rule->get_value( ).

  CREATE OBJECT lo_node
    EXPORTING
      iv_type     = gc_nonterminal
      iv_value    = lv_rulename
      iv_rulename = iv_rulename.

  io_before->edge( lo_node ).
  lo_node->edge( io_after ).

ENDMETHOD.


METHOD build_option.

  DATA: li_child TYPE REF TO if_ixml_node,
        lo_dummy TYPE REF TO lcl_node.


  CREATE OBJECT lo_dummy
    EXPORTING
      iv_type     = gc_dummy
      iv_value    = 'Option'
      iv_rulename = iv_rulename.                            "#EC NOTEXT

  li_child = ii_rule->get_first_child( ).

  io_before->edge( lo_dummy ).

  build( ii_rule   = li_child
         iv_rulename = iv_rulename
         io_before = lo_dummy
         io_after  = io_after ).

* easy way should be the last option/edge
  lo_dummy->edge( io_after ).

ENDMETHOD.


METHOD build_optionlist.

  DATA: li_children     TYPE REF TO if_ixml_node_list,
        li_append       TYPE REF TO if_ixml_node_list,
        li_child        TYPE REF TO if_ixml_node,
        lv_last         TYPE abap_bool,
        lo_before       TYPE REF TO lcl_node,
        lo_after        TYPE REF TO lcl_node,
        lo_seq_before   TYPE REF TO lcl_node,
        lo_seq_after    TYPE REF TO lcl_node,
        lt_opt          TYPE TABLE OF REF TO if_ixml_node_list,
        li_opt          LIKE LINE OF lt_opt.


  li_children = ii_rule->get_children( ).
  DO li_children->get_length( ) TIMES.
    li_child = li_children->get_item( sy-index - 1 ).
    li_append = li_child->get_children( ). " get rid of <Opt> tag
    APPEND li_append TO lt_opt.
  ENDDO.

  lo_before = io_before.

  LOOP AT lt_opt INTO li_opt.
    IF sy-tabix = lines( lt_opt ).
      lo_after = io_after.
    ELSE.
      CREATE OBJECT lo_after
        EXPORTING
          iv_type     = gc_dummy
          iv_value    = 'Optionlist'
          iv_rulename = iv_rulename.                        "#EC NOTEXT
    ENDIF.
    lo_before->edge( lo_after ).

    lv_last = abap_false.

    lo_seq_before = lo_before.

    DO li_opt->get_length( ) TIMES.
      IF li_opt->get_length( ) = sy-index.
        lv_last = abap_true.
      ENDIF.

      CREATE OBJECT lo_seq_after
        EXPORTING
          iv_type     = gc_dummy
          iv_value    = 'Optionlist Seq'
          iv_rulename = iv_rulename.                        "#EC NOTEXT

      li_child = li_opt->get_item( sy-index - 1 ).
      build( ii_rule   = li_child
             iv_rulename = iv_rulename
             io_before = lo_seq_before
             io_after  = lo_seq_after ).

      IF lv_last = abap_true.
        lo_seq_after->edge( lo_after ).
      ELSE.
        lo_seq_before = lo_seq_after.
      ENDIF.

    ENDDO.

    lo_before = lo_after.
  ENDLOOP.

ENDMETHOD.


METHOD build_permutation.

  TYPES: BEGIN OF st_pair,
           before TYPE REF TO lcl_node,
           after TYPE REF TO lcl_node,
         END OF st_pair.

  DATA: li_append     TYPE REF TO if_ixml_node_list,
        li_child      TYPE REF TO if_ixml_node,
        lv_index      TYPE i,
        lo_before     TYPE REF TO lcl_node,
        lv_name       TYPE string,
        lo_after      TYPE REF TO lcl_node,
        lo_seq_before TYPE REF TO lcl_node,
        lo_seq_after  TYPE REF TO lcl_node,
        lt_pair       TYPE TABLE OF st_pair,
        lt_per        TYPE TABLE OF REF TO if_ixml_node_list,
        li_children   LIKE LINE OF lt_per.

  FIELD-SYMBOLS: <ls_pair> LIKE LINE OF lt_pair,
                 <ls_to>   LIKE LINE OF lt_pair.


* good enough, but allows statements like ASCENDING ASCENDING

  li_children = ii_rule->get_children( ).
  DO li_children->get_length( ) TIMES.
    li_child = li_children->get_item( sy-index - 1 ).
    li_append = li_child->get_children( ). " get rid of <Per> tag
    APPEND li_append TO lt_per.
  ENDDO.

  LOOP AT lt_per INTO li_children.

    CREATE OBJECT lo_before
      EXPORTING
        iv_type     = gc_dummy
        iv_value    = 'PerBefore'
        iv_rulename = iv_rulename.
    io_before->edge( lo_before ).

    CREATE OBJECT lo_after
      EXPORTING
        iv_type     = gc_dummy
        iv_value    = 'PerAfter'
        iv_rulename = iv_rulename.
    lo_after->edge( io_after ).

    APPEND INITIAL LINE TO lt_pair ASSIGNING <ls_pair>.
    <ls_pair>-before = lo_before.
    <ls_pair>-after  = lo_after.

    DO li_children->get_length( ) TIMES.
      lv_index = sy-index.

      li_child = li_children->get_item( sy-index - 1 ).

* permutations are always treated as optional, so make sure its not possible
* to cycle in the graph without meeting terminals
      IF li_children->get_length( ) = 1.
        lv_name = li_child->get_name( ).
        IF lv_name = 'Option'.
          li_child = li_child->get_first_child( ).
        ENDIF.
      ENDIF.

* handle un<Sequence>d permutations
      IF lv_index = 1.
        lo_seq_before = lo_before.
      ELSE.
        lo_seq_before = lo_seq_after.
      ENDIF.

      CREATE OBJECT lo_seq_after
        EXPORTING
          iv_type     = gc_dummy
          iv_value    = 'PerSeq'
          iv_rulename = iv_rulename.

      build( ii_rule   = li_child
             iv_rulename = iv_rulename
             io_before = lo_seq_before
             io_after  = lo_seq_after ).

      IF lv_index = li_children->get_length( ).
        lo_seq_after->edge( lo_after ).
      ENDIF.

    ENDDO.

  ENDLOOP.

  LOOP AT lt_pair ASSIGNING <ls_pair>.
    LOOP AT lt_pair ASSIGNING <ls_to> WHERE before <> <ls_pair>-before.
      <ls_pair>-after->edge( <ls_to>-before ).
    ENDLOOP.
  ENDLOOP.

* easy way as last option
  io_before->edge( io_after ).

ENDMETHOD.


METHOD build_role.

  DATA: lo_node  TYPE REF TO lcl_node,
        lv_value TYPE string.


  lv_value = ii_rule->get_value( ).


  CREATE OBJECT lo_node
    EXPORTING
      iv_type     = gc_role
      iv_value    = lv_value
      iv_rulename = iv_rulename.

  io_before->edge( lo_node ).
  lo_node->edge( io_after ).

ENDMETHOD.


METHOD build_sequence.

  DATA: lo_before   TYPE REF TO lcl_node,
        lo_after    TYPE REF TO lcl_node,
        li_children TYPE REF TO if_ixml_node_list,
        li_child    TYPE REF TO if_ixml_node.


  li_children = ii_rule->get_children( ).

  CREATE OBJECT lo_before
    EXPORTING
      iv_type     = gc_dummy
      iv_value    = 'Sequence'                              "#EC NOTEXT
      iv_rulename = iv_rulename.
  io_before->edge( lo_before ).

  DO li_children->get_length( ) TIMES.
    IF sy-index = li_children->get_length( ).
      lo_after = io_after.
    ELSE.
      CREATE OBJECT lo_after
        EXPORTING
          iv_type     = gc_dummy
          iv_value    = 'Sequence'
          iv_rulename = iv_rulename.                        "#EC NOTEXT
    ENDIF.
    li_child = li_children->get_item( sy-index - 1 ).
    build( ii_rule     = li_child
           iv_rulename = iv_rulename
           io_before   = lo_before
           io_after    = lo_after ).
    lo_before = lo_after.
  ENDDO.

ENDMETHOD.


METHOD build_terminal.

  DATA: lo_node  TYPE REF TO lcl_node,
        lv_value TYPE string.


  lv_value = ii_rule->get_value( ).


  CREATE OBJECT lo_node
    EXPORTING
      iv_type     = gc_terminal
      iv_value    = lv_value
      iv_rulename = iv_rulename.

  io_before->edge( lo_node ).
  lo_node->edge( io_after ).

ENDMETHOD.


METHOD graph_build.

  DATA: li_rule TYPE REF TO if_ixml_node.


  li_rule = xml_get( iv_rulename ).

  CREATE OBJECT eo_start
    EXPORTING
      iv_type     = gc_start
      iv_value    = iv_rulename
      iv_rulename = iv_rulename.

  CREATE OBJECT eo_end
    EXPORTING
      iv_type     = gc_end
      iv_value    = iv_rulename
      iv_rulename = iv_rulename.

  build( ii_rule   = li_rule
         iv_rulename = iv_rulename
         io_before = eo_start
         io_after  = eo_end ).

  IF gv_debug = abap_true.
    graph_download(
        iv_rulename = iv_rulename
        io_start    = eo_start ).
  ENDIF.

ENDMETHOD.


METHOD graph_download.

  DATA: lv_text     TYPE string,
        lv_desktop  TYPE string,
        lv_filename TYPE string,
        lt_data     TYPE TABLE OF string.


  cl_gui_frontend_services=>get_desktop_directory(
    CHANGING
      desktop_directory    = lv_desktop
    EXCEPTIONS
      cntl_error           = 1
      error_no_gui         = 2
      not_supported_by_gui = 3
      OTHERS               = 4 ).
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  cl_gui_cfw=>flush( ).

  lv_text = graph_to_text( io_start ).
  CLEAR lt_data.
  APPEND lv_text TO lt_data.

  lv_filename = lv_desktop && '\graphviz\' && iv_rulename && '.txt'. "#EC NOTEXT

  cl_gui_frontend_services=>gui_download(
    EXPORTING
      filename                  = lv_filename
    CHANGING
      data_tab                  = lt_data
    EXCEPTIONS
      file_write_error          = 1
      no_batch                  = 2
      gui_refuse_filetransfer   = 3
      invalid_type              = 4
      no_authority              = 5
      unknown_error             = 6
      header_not_allowed        = 7
      separator_not_allowed     = 8
      filesize_not_allowed      = 9
      header_too_long           = 10
      dp_error_create           = 11
      dp_error_send             = 12
      dp_error_write            = 13
      unknown_dp_error          = 14
      access_denied             = 15
      dp_out_of_memory          = 16
      disk_full                 = 17
      dp_timeout                = 18
      file_not_found            = 19
      dataprovider_exception    = 20
      control_flush_error       = 21
      not_supported_by_gui      = 22
      error_no_gui              = 23
      OTHERS                    = 24 ).
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDMETHOD.


METHOD graph_to_text.

* see http://www.graphviz.org/

  DATA: lt_nodes TYPE TABLE OF REF TO lcl_node,
        lv_label TYPE string,
        lo_node  LIKE LINE OF lt_nodes,
        lv_node  TYPE string,
        lo_edge  LIKE LINE OF lo_node->mt_edges,
        lv_edge  TYPE string,
        lv_value TYPE string.


  DEFINE _out.
    rv_text = rv_text && &1 && cl_abap_char_utilities=>cr_lf.
  END-OF-DEFINITION.

  APPEND io_node TO lt_nodes.

  _out 'digraph {'.                                         "#EC NOTEXT
  LOOP AT lt_nodes INTO lo_node.
    lv_value = lo_node->mv_value.

* escape some characters
    REPLACE ALL OCCURRENCES OF '>' IN lv_value WITH '\>'.
    REPLACE ALL OCCURRENCES OF '<' IN lv_value WITH '\<'.

    lv_label = 'Type\n' && lo_node->mv_type && '|' &&
               'Key\n' && lo_node->mv_key && '|' &&
               'Value\n' && lv_value.                       "#EC NOTEXT
    lv_node = 'node' && lo_node->mv_key &&
              ' [label = "' && lv_label &&
              '" shape = "record"];'.                       "#EC NOTEXT
    _out lv_node.
    LOOP AT lo_node->mt_edges INTO lo_edge.
      lv_edge = 'node' && lo_node->mv_key &&
                ' -> node' && lo_edge->mv_key && ';'.       "#EC NOTEXT
      _out lv_edge.
      READ TABLE lt_nodes FROM lo_edge TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0.
        APPEND lo_edge TO lt_nodes.
      ENDIF.
    ENDLOOP.
  ENDLOOP.
  _out '}'.

ENDMETHOD.


METHOD parse.

  DATA: lo_start TYPE REF TO lcl_node.

  FIELD-SYMBOLS: <ls_statement> LIKE LINE OF it_statements,
                 <ls_token>     LIKE LINE OF it_tokens.


  READ TABLE it_statements WITH KEY terminator = space TRANSPORTING NO FIELDS.
  IF sy-subrc = 0 AND gv_end_rule = 'START'.
    rs_result-match = abap_false.
    RETURN.
  ENDIF.

  LOOP AT it_statements ASSIGNING <ls_statement>.

    CLEAR gt_tokens.
    LOOP AT it_tokens ASSIGNING <ls_token> FROM <ls_statement>-from TO <ls_statement>-to.
      APPEND <ls_token>-str TO gt_tokens.
    ENDLOOP.
    IF gv_end_rule = 'START'.
      APPEND '.' TO gt_tokens.
    ENDIF.

    graph_build( EXPORTING iv_rulename = gv_end_rule
                 IMPORTING eo_start = lo_start ).

    rs_result = walk( io_node  = lo_start
                      iv_index = 1 ).
    IF rs_result-match = abap_false.
      RETURN.
    ENDIF.

* todo, result-tokens if there are multiple statements

  ENDLOOP.

  IF sy-subrc = 0.
    rs_result-match = abap_true.
  ELSE.
    rs_result-match = abap_false.
  ENDIF.

ENDMETHOD.


METHOD run.

* abapOpenChecks
* https://github.com/larshp/abapOpenChecks
* MIT License

  DATA: lt_tokens     TYPE stokesx_tab,
        lt_res_tok    LIKE rs_result-tokens,
        lv_index      TYPE i,
        lt_statements TYPE sstmnt_tab.

  FIELD-SYMBOLS: <ls_res_tok> LIKE LINE OF lt_res_tok.


  SCAN ABAP-SOURCE it_code
       TOKENS          INTO lt_tokens
       STATEMENTS      INTO lt_statements
       WITH ANALYSIS.

  gv_debug          = iv_debug.
  gv_end_rule       = iv_rule.
  gv_allow_obsolete = iv_allow_obsolete.

  rs_result = parse( it_tokens     = lt_tokens
                     it_statements = lt_statements ).

* reverse token order
  lt_res_tok = rs_result-tokens.
  CLEAR rs_result-tokens[].
  lv_index = lines( lt_res_tok ).
  DO lines( lt_res_tok ) TIMES.
    READ TABLE lt_res_tok INDEX lv_index ASSIGNING <ls_res_tok>.
    APPEND <ls_res_tok> TO rs_result-tokens.
    lv_index = lv_index - 1.
  ENDDO.

ENDMETHOD.


METHOD walk.

  CASE io_node->mv_type.
    WHEN gc_dummy OR gc_start.
      rs_result = walk_node( io_node = io_node
                             iv_index = iv_index ).
    WHEN gc_end.
      rs_result = walk_end( io_node = io_node
                            iv_index = iv_index ).
    WHEN gc_role.
      rs_result = walk_role( io_node = io_node
                             iv_index = iv_index ).
    WHEN gc_terminal.
      rs_result = walk_terminal( io_node = io_node
                                 iv_index = iv_index ).
    WHEN gc_nonterminal.
      rs_result = walk_nonterminal( io_node = io_node
                                    iv_index = iv_index ).
  ENDCASE.

ENDMETHOD.


METHOD walk_end.

  IF iv_index = lines( gt_tokens ) + 1
      AND io_node->mv_value = gv_end_rule.
    rs_result-match = abap_true.
    RETURN.
  ENDIF.

  rs_result = walk_node( io_node  = io_node
                         iv_index = iv_index ).

ENDMETHOD.


METHOD walk_node.

  DATA: lo_node LIKE LINE OF io_node->mt_edges.


  LOOP AT io_node->mt_edges INTO lo_node.
    rs_result = walk( io_node  = lo_node
                      iv_index = iv_index ).
    IF rs_result-match = abap_true.
      RETURN.
    ENDIF.
  ENDLOOP.

ENDMETHOD.


METHOD walk_nonterminal.

  DATA: lv_rulename TYPE string,
        lo_start    TYPE REF TO lcl_node,
        lo_end      TYPE REF TO lcl_node,
        lo_node     LIKE LINE OF io_node->mt_edges.


  lv_rulename = io_node->mv_value.

  IF lv_rulename = 'MACRO'.
* macro call makes everything valid ABAP code
    rs_result-match = abap_false.
    RETURN.
  ENDIF.

  graph_build(
    EXPORTING
      iv_rulename = lv_rulename
    IMPORTING
      eo_start    = lo_start
      eo_end      = lo_end ).

  ASSERT lo_start IS BOUND.
  ASSERT lo_end IS BOUND.

* add edges from io_node to end of nonterminal graph
  LOOP AT io_node->mt_edges INTO lo_node.
    lo_end->edge( lo_node ).
  ENDLOOP.

  rs_result = walk_node( io_node  = lo_start
                         iv_index = iv_index ).

ENDMETHOD.


METHOD walk_role.

  DATA: lv_token LIKE LINE OF gt_tokens.

  FIELD-SYMBOLS: <ls_token> LIKE LINE OF rs_result-tokens.


  READ TABLE gt_tokens INDEX iv_index INTO lv_token.
  IF sy-subrc <> 0.
    rs_result-match = abap_false.
    RETURN.
  ENDIF.

  CASE io_node->mv_value.
    WHEN 'FieldId' OR 'FieldIdW'.
      FIND REGEX '^[a-zA-Z0-9_\-=<>~+]+["\[\]"]*["("0-9")"]*$' IN lv_token. "#EC NOTEXT
      IF sy-subrc <> 0.
        FIND REGEX '^''.*''["("0-9")"]*$' IN lv_token.
      ENDIF.
    WHEN 'FieldDefId'.
      FIND REGEX '^[a-zA-Z0-9_\-]+["("0-9")"]*$' IN lv_token. "#EC NOTEXT
    WHEN 'TypeId'
        OR 'ScreenId'
        OR 'ItabFieldId'.
      FIND REGEX '^[a-zA-Z0-9_\-=>~]+$' IN lv_token.        "#EC NOTEXT
    WHEN 'FieldListId'
        OR 'LdbNodeId'
        OR 'MacroId'
        OR 'MethodDefId'
        OR 'FormParamId'
        OR 'FormId'
        OR 'FormDefId'
        OR 'ClasstypeDefId'
        OR 'SwitchId'
        OR 'BlockDefId'
        OR 'ClassexcTypeId'
        OR 'FieldGroupId'
        OR 'ProgramId'
        OR 'ProgramDefId'
        OR 'MacroDefId'
        OR 'ClassexcrefFieldId'
        OR 'FieldCompId'.
      FIND REGEX '^[a-zA-Z0-9_]+$' IN lv_token.             "#EC NOTEXT
    WHEN 'ClassrefFieldId'.
      FIND REGEX '^[a-zA-Z0-9_]+$' IN lv_token.             "#EC NOTEXT
    WHEN 'FunctionId'.
      FIND REGEX '^''.*''$' IN lv_token.
    WHEN 'MethodId('.
      FIND REGEX '^[a-zA-Z0-9_\=\->~]+\($' IN lv_token.     "#EC NOTEXT
    WHEN 'MethodId'.
      FIND REGEX '^[a-zA-Z0-9_\=\->~]+\(?$' IN lv_token.    "#EC NOTEXT
    WHEN 'LocationId'.
      FIND REGEX '^/?[0-9]*["("0-9")"]*$' IN lv_token.
    WHEN 'SelOptId'.
      rs_result-match = abap_false.
      RETURN.
    WHEN 'FieldSymbolDefId'.
      FIND REGEX '^<[a-zA-Z0-9_\-]+>$' IN lv_token.         "#EC NOTEXT
    WHEN 'ComponentId'.
      FIND REGEX '^[a-zA-Z0-9_\*]+$' IN lv_token.           "#EC NOTEXT
    WHEN 'MessageNumber'.
      FIND REGEX '^.[0-9][0-9][0-9](\(.+\))?$' IN lv_token.
  ENDCASE.

  IF sy-subrc = 0.
    rs_result = walk_node( io_node  = io_node
                           iv_index = iv_index + 1 ).
    IF rs_result-match = abap_true.
      APPEND INITIAL LINE TO rs_result-tokens ASSIGNING <ls_token>.
      <ls_token>-type     = c_role.
      <ls_token>-value    = io_node->mv_value.
      <ls_token>-code     = lv_token.
      <ls_token>-rulename = io_node->mv_rulename.
    ENDIF.
  ELSE.
    rs_result-match = abap_false.
  ENDIF.

ENDMETHOD.


METHOD walk_terminal.

  DATA: lv_token LIKE LINE OF gt_tokens.

  FIELD-SYMBOLS: <ls_token> LIKE LINE OF rs_result-tokens.


  rs_result-match = abap_true.

  READ TABLE gt_tokens INDEX iv_index INTO lv_token.
  IF sy-subrc <> 0.
    rs_result-match = abap_false.
  ENDIF.

  CASE io_node->mv_value.
    WHEN '#ILITERAL#'.
      FIND REGEX '^[0-9]+$' IN lv_token.
      IF sy-subrc <> 0.
        rs_result-match = abap_false.
      ENDIF.
    WHEN OTHERS.
      IF lv_token <> io_node->mv_value.
        rs_result-match = abap_false.
      ENDIF.
  ENDCASE.

  IF rs_result-match = abap_false.
    RETURN.
  ENDIF.

  rs_result = walk_node( io_node  = io_node
                         iv_index = iv_index + 1 ).

  IF rs_result-match = abap_true.
    APPEND INITIAL LINE TO rs_result-tokens ASSIGNING <ls_token>.
    <ls_token>-type     = c_terminal.
    <ls_token>-value    = io_node->mv_value.
    <ls_token>-code     = lv_token.
    <ls_token>-rulename = io_node->mv_rulename.
  ENDIF.

ENDMETHOD.


METHOD xml_download.

  DATA: lv_desktop       TYPE string,
        lv_filename      TYPE string,
        lv_xml           TYPE string,
        lt_data          TYPE TABLE OF string,
        li_ostream       TYPE REF TO if_ixml_ostream,
        li_renderer      TYPE REF TO if_ixml_renderer,
        li_streamfactory TYPE REF TO if_ixml_stream_factory.


  cl_gui_frontend_services=>get_desktop_directory(
    CHANGING
      desktop_directory    = lv_desktop
    EXCEPTIONS
      cntl_error           = 1
      error_no_gui         = 2
      not_supported_by_gui = 3
      OTHERS               = 4 ).
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  cl_gui_cfw=>flush( ).

  li_streamfactory = ii_xml->create_stream_factory( ).
  li_ostream = li_streamfactory->create_ostream_cstring( lv_xml ).
  li_renderer = ii_xml->create_renderer( ostream  = li_ostream
                                         document = ii_xml_doc ).
  li_renderer->set_normalizing( ).
  li_renderer->render( ).

* make sure newlines work in notepad
  REPLACE ALL OCCURRENCES OF cl_abap_char_utilities=>newline
    IN lv_xml WITH cl_abap_char_utilities=>cr_lf.

  APPEND lv_xml TO lt_data.

  lv_filename = lv_desktop && '\graphviz\' && iv_rulename && '.xml'. "#EC NOTEXT

  cl_gui_frontend_services=>gui_download(
    EXPORTING
      filename                  = lv_filename
    CHANGING
      data_tab                  = lt_data
    EXCEPTIONS
      file_write_error          = 1
      no_batch                  = 2
      gui_refuse_filetransfer   = 3
      invalid_type              = 4
      no_authority              = 5
      unknown_error             = 6
      header_not_allowed        = 7
      separator_not_allowed     = 8
      filesize_not_allowed      = 9
      header_too_long           = 10
      dp_error_create           = 11
      dp_error_send             = 12
      dp_error_write            = 13
      unknown_dp_error          = 14
      access_denied             = 15
      dp_out_of_memory          = 16
      disk_full                 = 17
      dp_timeout                = 18
      file_not_found            = 19
      dataprovider_exception    = 20
      control_flush_error       = 21
      not_supported_by_gui      = 22
      error_no_gui              = 23
      OTHERS                    = 24 ).
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

ENDMETHOD.


METHOD xml_fix.

  WHILE sy-subrc = 0.
    REPLACE ALL OCCURRENCES OF REGEX
      '<Terminal>([A-Z-]*)</Terminal>' &&
      '<Terminal>#NWS_MINUS_NWS#</Terminal>' &&
      '<Terminal>([A-Z-]*)</Terminal>'
      IN cv_xml
      WITH '<Terminal>$1-$2</Terminal>' IGNORING CASE.
  ENDWHILE.

  REPLACE ALL OCCURRENCES OF REGEX
    '<Role>MethodId</Role><Terminal>#NWS_LPAREN#</Terminal>'
    IN cv_xml
    WITH '<Role>MethodId(</Role>' IGNORING CASE.
* todo #RPAREN_NWS# ?


  REPLACE ALL OCCURRENCES OF REGEX '<Terminal>#LPAREN#</Terminal>'
    IN cv_xml
    WITH '<Terminal>(</Terminal>' IGNORING CASE.
  REPLACE ALL OCCURRENCES OF REGEX '<Terminal>#RPAREN#</Terminal>'
    IN cv_xml
    WITH '<Terminal>)</Terminal>' IGNORING CASE.


  REPLACE ALL OCCURRENCES OF REGEX '<Terminal>#PLUS#</Terminal>'
    IN cv_xml
    WITH '<Terminal>+</Terminal>' IGNORING CASE.
  REPLACE ALL OCCURRENCES OF REGEX '<Terminal>#MINUS#</Terminal>'
    IN cv_xml
    WITH '<Terminal>-</Terminal>' IGNORING CASE.
  REPLACE ALL OCCURRENCES OF REGEX '<Terminal>#ASTERISK#</Terminal>'
    IN cv_xml
    WITH '<Terminal>*</Terminal>' IGNORING CASE.
  REPLACE ALL OCCURRENCES OF REGEX '<Terminal>#SLASH#</Terminal>'
    IN cv_xml
    WITH '<Terminal>/</Terminal>' IGNORING CASE.

* #ASTERISK_NWS# ?

  REPLACE ALL OCCURRENCES OF REGEX '<Terminal>%_SORTMODE</Terminal>'
      IN cv_xml
      WITH '' IGNORING CASE.

* comparison operators
  REPLACE ALL OCCURRENCES OF REGEX
    '<Terminal>#LT_NWS#</Terminal><Terminal>#NWS_GT#</Terminal>'
    IN cv_xml
    WITH '<Terminal>&lt;&gt;</Terminal>' IGNORING CASE.
  REPLACE ALL OCCURRENCES OF REGEX
    '<Terminal>#GT_NWS#</Terminal><Terminal>#NWS_LT#</Terminal>'
    IN cv_xml
    WITH '<Terminal>&gt;&lt;</Terminal>' IGNORING CASE.
  REPLACE ALL OCCURRENCES OF REGEX '<Terminal>#LT#</Terminal>'
    IN cv_xml
    WITH '<Terminal>&lt;</Terminal>' IGNORING CASE.
  REPLACE ALL OCCURRENCES OF REGEX '<Terminal>#LT_NWS#</Terminal><Terminal>=</Terminal>'
    IN cv_xml
    WITH '<Terminal>&lt;=</Terminal>' IGNORING CASE.
  REPLACE ALL OCCURRENCES OF REGEX '<Terminal>=</Terminal><Terminal>#NWS_LT#</Terminal>'
    IN cv_xml
    WITH '<Terminal>=&lt;</Terminal>' IGNORING CASE.
  REPLACE ALL OCCURRENCES OF REGEX '<Terminal>#GT#</Terminal>'
    IN cv_xml
    WITH '<Terminal>&gt;</Terminal>' IGNORING CASE.
  REPLACE ALL OCCURRENCES OF REGEX '<Terminal>#GT_NWS#</Terminal><Terminal>=</Terminal>'
    IN cv_xml
    WITH '<Terminal>&gt;=</Terminal>' IGNORING CASE.

ENDMETHOD.


METHOD xml_get.

  TYPES: BEGIN OF ty_cache,
           rulename TYPE string,
           node     TYPE REF TO if_ixml_node,
         END OF ty_cache.

  STATICS: st_syntax TYPE syntax_tt,
           st_cache TYPE SORTED TABLE OF ty_cache WITH UNIQUE KEY rulename.

  DATA: lv_rulename TYPE ssyntaxstructure-rulename,
        ls_cache    LIKE LINE OF st_cache.

  FIELD-SYMBOLS: <ls_syntax> LIKE LINE OF st_syntax.


  READ TABLE st_cache INTO ls_cache WITH KEY rulename = iv_rulename.
  IF sy-subrc = 0.
    ri_rule = ls_cache-node.
    RETURN.
  ENDIF.

  IF st_syntax[] IS INITIAL.
    SELECT * FROM ssyntaxstructure INTO TABLE st_syntax.    "#EC *
    SORT st_syntax BY rulename ASCENDING.
  ENDIF.

  lv_rulename = iv_rulename. " type conversion
  READ TABLE st_syntax ASSIGNING <ls_syntax>
    WITH KEY rulename = lv_rulename BINARY SEARCH.
  ASSERT sy-subrc = 0.

  xml_fix( CHANGING cv_xml = <ls_syntax>-description ).

  ri_rule = xml_parse( iv_rulename = iv_rulename
                       iv_xml      = <ls_syntax>-description ).

  CLEAR ls_cache.
  ls_cache-rulename = iv_rulename.
  ls_cache-node     = ri_rule.
  INSERT ls_cache INTO TABLE st_cache.

ENDMETHOD.


METHOD xml_parse.

  DATA: li_ixml           TYPE REF TO if_ixml,
        li_xml_doc        TYPE REF TO if_ixml_document,
        li_type           TYPE REF TO if_ixml_node,
        li_attr           TYPE REF TO if_ixml_named_node_map,
        lv_type           TYPE string,
        li_collection     TYPE REF TO if_ixml_node_collection,
        li_iterator       TYPE REF TO if_ixml_node_iterator,
        li_node           TYPE REF TO if_ixml_node,
        li_normal         TYPE REF TO if_ixml_node,
        li_obsolete       TYPE REF TO if_ixml_node,
        li_private        TYPE REF TO if_ixml_node,
        li_stream_factory TYPE REF TO if_ixml_stream_factory,
        li_istream        TYPE REF TO if_ixml_istream,
        li_parser         TYPE REF TO if_ixml_parser.


  li_ixml = cl_ixml=>create( ).
  li_xml_doc = li_ixml->create_document( ).

  li_stream_factory = li_ixml->create_stream_factory( ).
  li_istream = li_stream_factory->create_istream_string( iv_xml ).
  li_parser = li_ixml->create_parser( stream_factory = li_stream_factory
                                      istream        = li_istream
                                      document       = li_xml_doc ).
  ASSERT li_parser->parse( ) = 0.

  li_istream->close( ).

  IF gv_debug = abap_true.
    xml_download(
        iv_rulename = iv_rulename
        ii_xml      = li_ixml
        ii_xml_doc  = li_xml_doc ).
  ENDIF.

  li_collection =
    li_xml_doc->get_elements_by_tag_name( depth = 0 name = 'View' ). "#EC NOTEXT

  li_iterator = li_collection->create_iterator( ).
  li_node = li_iterator->get_next( ).
  WHILE li_node IS BOUND.

    li_attr = li_node->get_attributes( ).
    li_type = li_attr->get_named_item( 'type' ).            "#EC NOTEXT
    lv_type = li_type->get_value( ).
    CASE lv_type.
      WHEN 'Normal'.                                        "#EC NOTEXT
        li_normal = li_node.
      WHEN 'Obsolete'.                                      "#EC NOTEXT
        li_obsolete = li_node.
      WHEN 'Private'.                                       "#EC NOTEXT
        li_private = li_node.
    ENDCASE.

    li_node = li_iterator->get_next( ).
  ENDWHILE.

  IF li_obsolete IS BOUND AND gv_allow_obsolete = abap_true.
    ri_rule = li_obsolete->get_first_child( ).
  ELSEIF li_normal IS BOUND.
    ri_rule = li_normal->get_first_child( ).
  ELSEIF li_private IS BOUND.
    ri_rule = li_private->get_first_child( ).
  ENDIF.

ENDMETHOD.
ENDCLASS.