PROGRAM_NAME='EIB_Tools'
(***********************************************************)
(*  FILE CREATED ON: 07/12/2006  AT: 12:59:50              *)
(***********************************************************)
(*  FILE_LAST_MODIFIED_ON: 07/19/2006  AT: 18:39:47        *)
(***********************************************************)
(*
Diese Includedatei enthaelt Funktionen um die Einbindung von EIB
zu erleichtern
Hier keine Veraenderungen an dieser Datei vornehmen !

This Include file contains functions to simplify implemnting EIB
DO NOT CHANGE anything inside of this file !
*)

// Sichertstellen, das Funktionen nur einmal eingebunden werden
// Make shure Include File is only included once
#IF_NOT_DEFINED __CTEIB6__
#DEFINE __CTEIB6__

(***********************************************************)
(*               CONSTANT DEFINITIONS GO BELOW             *)
(***********************************************************)
DEFINE_CONSTANT
// Konstanten für Aktor Typen
// Constants for Actor Types
CHAR eibSWITCH[] 	= { 'SWITCH' }
CHAR eibDIM4[] 		= { 'DIM4' }
CHAR eib1BYTE[] 	= { '1BYTE' }
CHAR eib2BYTE[] 	= { '2BYTE' }
CHAR eib3BYTE[] 	= { '3BYTE' }
CHAR eib4BYTE[] 	= { '4BYTE' }
CHAR eibTEXT[] 		= { 'TEXT' }
CHAR eibHEXTEXT[] 	= { 'HEXTEXT' }

// Konstanten für Licht Dimmen
// Constants for dimming Lights
EIB_DIM_UP	= 9		// Heller, Brighter
EIB_DIM_DN	= 1		// Dunkler, Dark
EIB_DIM_SP	= 0		// Dimmen Stop, Dimming Stop

// Konstanten für Flags
// Constants for Flags
CHAR eibEIS5[]		= { 'EIS5' }
CHAR eibTIME[]		= { 'TIME' }
CHAR eibDATE[]		= { 'DATE' }
CHAR eibPollStart[]		= { 'PS' }

(*
Setzt Aktor "nAmxNr" auf Wert "lValue"
Set actor "nAmxNr" to value "lValue"
*)
DEFINE_FUNCTION EIBSet(DEV vdvEIB, INTEGER nAmxNr, LONG lValue)
{
	SEND_COMMAND vdvEIB,"'SET=', ITOA(nAmxNr), ':', ITOA(lValue)"
}

DEFINE_FUNCTION EIS5Set(DEV vdvEIB, INTEGER nAmxNr, LONG lValue)
{
	SEND_COMMAND vdvEIB,"'EIS5=', ITOA(nAmxNr), ':', ITOA(lValue)"
}

(*
Holt den im Modul gespeicherten Wert für "nAmxNr"
Polls the vaule stored inside of the module for "nAmxNr"
*)
DEFINE_FUNCTION EIBGet(DEV vdvEIB, INTEGER nAmxNr)
{
	SEND_COMMAND vdvEIB,"'GET=', ITOA(nAmxNr)"
}

(*
Pollt den Aktor "nAmxNr"
Polls the current value of "nAmxNr"
*)
DEFINE_FUNCTION EIBPoll(DEV vdvEIB, INTEGER nAmxNr)
{
	SEND_COMMAND vdvEIB,"'POLL=', ITOA(nAmxNr)"
}

(*
Fügt einen Aktor hinzu
Adds an Aktor to the List
Parameters:
nNr:			Unique number to access this actor from the amx system
sTyp:			Type fo the actor (eibSWITCH, eib1BYTE, ....)
sGrpAdr:	Group address of the actor, either in 2 or 3 number notation ("1/3/5" or "1/20")
sFlags:		Komma seperated List of optional flags for this actor (eibSendEIS5, eibSendTIME, eibSendDATE, eibPOLLSTART)
*)
DEFINE_FUNCTION EIBAdd (DEV vdvEIB, INTEGER nNr, CHAR sTyp[], CHAR sGrpAdr[], CHAR sFlags[])
{
	SEND_COMMAND vdvEIB,"'ADD=', ITOA(nNr), ':', sTyp, ':', sGrpAdr, ':', sFlags"
}

(*
Pollt Aktor "nToPoll" wenn sich Aktor "nWhenPollNr" ändert
Polls actor "nToPoll" when "nWhenPollNr" change
*)
DEFINE_FUNCTION EIBWhenPoll (DEV vdvEIB, INTEGER nWhenNr, INTEGER nToPollNr)
{
	SEND_COMMAND vdvEIB,"'WHEN=', ITOA(nWhenNr), ':', ITOA(nToPollNr)"
}

(*
wandelt kommaseparierte Rueckmeldung (14Bytes Hex Daten)
in IntegerArray mit 14 Stellen
*)
DEFINE_FUNCTION INTEGER [14] EIBString2Array (CHAR	sArray[])
{
	STACK_VAR 	INTEGER		nVal[14]
							INTEGER		nCt
							CHAR			sVal[100]
	
	sVal = sArray
	nCT = 1
	WHILE(LENGTH_ARRAY(sVal))
	{
		nVal[nCt] = HEXTOI(sVal)
		IF (FIND_STRING(sVal, "','", 1) == 0)
		{
			sVal = ""
		}
		ELSE
		{
			REMOVE_STRING(sVal, "','", 1)
		}
		nCT++
		IF (nCt > LENGTH_ARRAY(sArray))	
			BREAK
	}
	RETURN nVal
}

(*
	wandelt ein Integerarray mit 14 Stellen in kommaseparierten String um
*)
DEFINE_FUNCTION CHAR[50] EIBArray2String(INTEGER nArray[])
{
	STACK_VAR	INTEGER		nCT
							CHAR			sTemp[50]
							INTEGER		nLen
	
	nLen = MAX_LENGTH_ARRAY(nArray)
	sTemp = ''
	IF (nLen > 14)
	{
		nLen = 14
	}
	FOR (nCT = 1; nCT <=nLen; nCT++)
	{
		sTemp = "sTemp,ITOHEX(narray[nCt]),','"
	}
	SET_LENGTH_ARRAY(sTemp,(LENGTH_ARRAY(sTemp)-1))
	RETURN sTemp
}

#END_IF
