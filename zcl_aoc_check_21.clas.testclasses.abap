*----------------------------------------------------------------------*
*       CLASS lcl_Test DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_test DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS
  FINAL.

  PRIVATE SECTION.
* ================

    DATA: mt_code   TYPE string_table,
          ms_result TYPE scirest_ad,
          mo_check  TYPE REF TO zcl_aoc_check_21.

    METHODS: setup,
             test001_01 FOR TESTING,
             test001_02 FOR TESTING,
             test001_03 FOR TESTING,
             test001_04 FOR TESTING,
             test001_05 FOR TESTING,
             test001_06 FOR TESTING.

ENDCLASS.       "lcl_Test

*----------------------------------------------------------------------*
*       CLASS lcl_Test IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_test IMPLEMENTATION.
* ==============================

  DEFINE _code.
    append &1 to mt_code.
  END-OF-DEFINITION.

  METHOD setup.
    CREATE OBJECT mo_check.
  ENDMETHOD.                    "setup

  METHOD test001_01.
* ===========

    _code 'FORM foobar USING pv_char type c.'.
    _code '  WRITE: / pv_char.'.
    _code 'ENDFORM.'.

    ms_result = zcl_aoc_unit_test=>check( it_code  = mt_code
                                          io_check = mo_check ).

    cl_abap_unit_assert=>assert_initial( ms_result-code ).

  ENDMETHOD.                    "test1

  METHOD test001_02.
* ===========

    _code 'FORM foobar USING pv_char type c.'.
    _code '  WRITE: / ''nope''.'.
    _code 'ENDFORM.'.

    ms_result = zcl_aoc_unit_test=>check( it_code  = mt_code
                                          io_check = mo_check ).

    cl_abap_unit_assert=>assert_equals( exp = '001'
                                        act = ms_result-code ).

  ENDMETHOD.                    "test001_02

  METHOD test001_03.
* ===========

    _code 'FORM foobar CHANGING pv_char type c.'.
    _code '  WRITE: / pv_char.'.
    _code 'ENDFORM.'.

    ms_result = zcl_aoc_unit_test=>check( it_code  = mt_code
                                          io_check = mo_check ).

    cl_abap_unit_assert=>assert_initial( ms_result-code ).

  ENDMETHOD.                    "test1

  METHOD test001_04.
* ===========

    _code 'FORM foobar CHANGING pv_char type c.'.
    _code '  WRITE: / ''nope''.'.
    _code 'ENDFORM.'.

    ms_result = zcl_aoc_unit_test=>check( it_code  = mt_code
                                          io_check = mo_check ).

    cl_abap_unit_assert=>assert_equals( exp = '001'
                                        act = ms_result-code ).

  ENDMETHOD.                    "test001_04

  METHOD test001_05.
* ===========

    _code 'FORM foobar TABLES pv_char type c.'.
    _code '  WRITE: / pv_char.'.
    _code 'ENDFORM.'.

    ms_result = zcl_aoc_unit_test=>check( it_code  = mt_code
                                          io_check = mo_check ).

    cl_abap_unit_assert=>assert_initial( ms_result-code ).

  ENDMETHOD.                    "test1

  METHOD test001_06.
* ===========

    _code 'FORM foobar TABLES pv_char type c.'.
    _code '  WRITE: / ''nope''.'.
    _code 'ENDFORM.'.

    ms_result = zcl_aoc_unit_test=>check( it_code  = mt_code
                                          io_check = mo_check ).

    cl_abap_unit_assert=>assert_equals( exp = '001'
                                        act = ms_result-code ).

  ENDMETHOD.                    "test001_06

ENDCLASS.       "lcl_Te