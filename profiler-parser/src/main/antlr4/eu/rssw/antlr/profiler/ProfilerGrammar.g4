/*
 * OpenEdge plugin for SonarQube
 * Copyright (c) 2015-2018 Riverside Software
 * contact AT riverside DASH software DOT fr
 * 
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 3 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02
 */
grammar ProfilerGrammar;

@parser::members {
  private int versionNumber = -1;
}

profiler:
  description module_data call_tree_data line_summary tracing_data coverage_data coverage_data2 statistics_data user_data;

description:
  version=NUMBER
    { try { versionNumber = Integer.parseInt($version.text) ; } catch (NumberFormatException uncaught) { } } 
  date=DATE desc=STRING time=TIME author=STRING
  json_data
  NEWLINE CHR_DOT NEWLINE;

json_data:
  { versionNumber >= 3 }?
  '{' STRING ':' ( NUMBER | FLOAT | STRING ) ( ',' STRING ':' ( NUMBER | FLOAT | STRING ) )* '}';

module_data:
  module_data_line* CHR_DOT NEWLINE;

module_data_line:
  id=NUMBER name=STRING debugListingFile=STRING crc=NUMBER ( NUMBER STRING )? NEWLINE;

call_tree_data:
  call_tree_data_line* CHR_DOT NEWLINE;

call_tree_data_line:
  callerId=NUMBER callerLineNum=NUMBER calleeId=NUMBER callCount=NUMBER NEWLINE;

line_summary:
  line_summary_line* CHR_DOT NEWLINE;

line_summary_line:
  moduleId=NUMBER lineNumber=NUMBER execCount=NUMBER actualTime=FLOAT cumulativeTime=FLOAT NEWLINE;

tracing_data:
  tracing_data_line* CHR_DOT NEWLINE;

tracing_data_line:
  moduleId=NUMBER lineNumber=NUMBER execTime=FLOAT timestamp=FLOAT NEWLINE;

coverage_data:
  coverage_section* CHR_DOT NEWLINE;

coverage_section:
  moduleId=NUMBER name=STRING lineCount=NUMBER NEWLINE coverage_section_line+ CHR_DOT NEWLINE;

coverage_section_line:
  linenum=NUMBER NEWLINE;

coverage_data2:
  { versionNumber == 3 }?
  coverage_section2_line* CHR_DOT NEWLINE;

coverage_section2_line:
  NUMBER NUMBER NUMBER NUMBER NUMBER FLOAT NUMBER* NEWLINE;

statistics_data:
  { versionNumber == 4 }?
  stats1_data stats2_data stats3_data stats4_data CHR_DOT NEWLINE;

stats1_data:
  stats1_line* CHR_DOT NEWLINE;

stats2_data:
  stats2_line* CHR_DOT NEWLINE;

stats3_data:
  stats3_line* CHR_DOT NEWLINE;

stats4_data:
  stats4_line* CHR_DOT NEWLINE;

stats1_line:
  NUMBER NUMBER NUMBER STRING NEWLINE;

stats2_line:
  NUMBER FLOAT FLOAT FLOAT FLOAT FLOAT FLOAT FLOAT FLOAT FLOAT FLOAT FLOAT FLOAT FLOAT FLOAT FLOAT FLOAT FLOAT FLOAT FLOAT FLOAT FLOAT FLOAT FLOAT FLOAT NEWLINE;

stats3_line:
  NUMBER NUMBER NUMBER NUMBER NEWLINE;

stats4_line:
  NUMBER NUMBER STRING NEWLINE;

user_data:
  user_data_line* CHR_DOT NEWLINE;

user_data_line:
  FLOAT STRING NEWLINE;

fragment INT:
  ('0'..'9');

NUMBER:
  '-'? INT+;

FLOAT:
  NUMBER '.' NUMBER;

DATE:
  ('0'..'9') ('0'..'9') '/' ('0'..'9') ('0'..'9') '/' ('0'..'9') ('0'..'9') ('0'..'9') ('0'..'9');

TIME:
  ('0'..'9') ('0'..'9') ':' ('0'..'9') ('0'..'9') ':' ('0'..'9') ('0'..'9');

STRING:
  '"' .*? '"' { setText(getText().substring(1, getText().length() - 1)); };

CHR_DOT:
  '.';

NEWLINE:
  '\r'? '\n';

WS:
  [ \t]+ -> channel(HIDDEN);
