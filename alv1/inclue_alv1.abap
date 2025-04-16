DATA : v_kunnr TYPE vbak-kunnr.
DATA: CNT TYPE REF TO cl_gui_custom_container,
      alv TYPE REF TO cl_gui_alv_grid.

types : begin of ty_kna1.
       include type zckna1.
types end of ty_kna1.
types : begin of ty_vbak,
  include type zcvbak.
types end of ty_vbak.

data : lt_kna1 type TABLE OF ty_kna1,
      ls_kna1 like line of lt_kna1,
      lt_vbak type table of ty_vbak,
      ls_vbak like line of lt_vbak.


class lcl_event_handler definition.
  PUBLIC SECTION.
  methods double_click_handler for event double_click of cl_gui_alv_grid IMPORTING e_row E_COLUMN.
ENDCLASS.

class lcl_event_handler IMPLEMENTATION.
  method double_click_handler.
*    MESSAGE 'double click' TYPE 'I'.
    case e_column.
      when 'KUNNR'.
    READ TABLE lt_kna1 into ls_kna1 index  e_row TRANSPORTING kunnr.
    if sy-subrc = 0.
      perform getvbak.
        call screen 200.
    endif.
    when others.
    message 'Select on the Customer column ' type 'I'.
    ENDCASE.
  ENDMETHOD.
ENDCLASS.
data: ob type ref to lcl_event_handler.
SELECT-OPTIONS so_kunnr FOR v_kunnr DEFAULT '1000' TO '1010'.



MODULE status_0100 OUTPUT.
  IF CNT IS NOT BOUND.
    SET PF-STATUS 'MENU'.
*    linking custom control with container.
    CREATE OBJECT CNT
    EXPORTING
      container_name              = 'CUST_CNTRL'.
*    Linking custom container with alv_grid.
    CREATE OBJECT alv
    EXPORTING
      i_parent          = CNT.
*   Fetching data that needs to be displayed.
    PERFORM get_customer_data.
*  If the data is available we will be displaying it in the alv_grid.
    IF LT_KNA1 IS NOT INITIAL.
* Registering handlers.
      PERFORM handlers.
* data display.
      PERFORM DISPLAY_DATA.
    ENDIF.
  ENDIF.
ENDMODULE.

MODULE user_command_0100 INPUT.
  CASE sy-ucomm.
  WHEN 'BACK'.
    LEAVE PROGRAM.
  ENDCASE.
ENDMODULE.

FORM get_customer_data .
  SELECT kunnr, land1, name1
  FROM kna1
  INTO TABLE @lt_kna1
        WHERE kunnr IN @so_kunnr.
    sort lt_kna1 by kunnr.
ENDFORM.
*&---------------------------------------------------------------------*
*& Form DISPLAY_DATA
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM display_data .
  if lt_kna1 is not INITIAL.
  CALL METHOD alv->set_table_for_first_display
  EXPORTING
    i_structure_name              = 'ZCKNA1'
  CHANGING
    it_outtab                     = lt_kna1.
  IF sy-subrc <> 0.
*           Implement suitable error handling here
  ENDIF.
  else.
    message 'NO Customer found' type 'I'.
  endif.
ENDFORM.

FORM handlers .
create OBJECT ob.
set HANDLER ob->double_click_handler for alv.
ENDFORM.

FORM getvbak .
select vbeln, erdat, ernam, erzet, netwr
  from vbak
  where kunnr = @ls_kna1-kunnr
  into table @lt_vbak.
ENDFORM.