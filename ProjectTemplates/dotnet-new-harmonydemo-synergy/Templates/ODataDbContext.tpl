<CODEGEN_FILENAME>DbContext.dbl</CODEGEN_FILENAME>
<REQUIRES_CODEGEN_VERSION>5.9.3</REQUIRES_CODEGEN_VERSION>
<REQUIRES_USERTOKEN>MODELS_NAMESPACE</REQUIRES_USERTOKEN>
;//****************************************************************************
;//
;// Title:       ODataDbContext.tpl
;//
;// Type:        CodeGen Template
;//
;// Description: Used to create OData DbContext classes in a Harmony Core environment
;//
;// Copyright (c) 2018, Synergex International, Inc. All rights reserved.
;//
;// Redistribution and use in source and binary forms, with or without
;// modification, are permitted provided that the following conditions are met:
;//
;// * Redistributions of source code must retain the above copyright notice,
;//   this list of conditions and the following disclaimer.
;//
;// * Redistributions in binary form must reproduce the above copyright notice,
;//   this list of conditions and the following disclaimer in the documentation
;//   and/or other materials provided with the distribution.
;//
;// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
;// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
;// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
;// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
;// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
;// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
;// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
;// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
;// POSSIBILITY OF SUCH DAMAGE.
;//
;;*****************************************************************************
;;
;; Title:       DbContext.dbl
;;
;; Description: OData DbContext class
;;
;;*****************************************************************************
;; WARNING: GENERATED CODE!
;; This file was generated by CodeGen. Avoid editing the file if possible.
;; Any changes you make will be lost of the file is re-generated.
;;*****************************************************************************

import Harmony.Core
import Harmony.Core.Context
import Harmony.Core.EF.Extensions
import Microsoft.EntityFrameworkCore
import System.Collections.Generic
import System.Linq.Expressions
import <MODELS_NAMESPACE>

namespace <NAMESPACE>

    ;;; <summary>
    ;;;
    ;;; </summary>
    public partial class DbContext extends Microsoft.EntityFrameworkCore.DbContext

        ;;; <summary>
        ;;; Construct a new DbContext.
        ;;; </summary>
        public method DbContext
            options, @DbContextOptions<DbContext>
            endparams
            parent(options)
        proc

        endmethod

<STRUCTURE_LOOP>
        ;;; <summary>
        ;;; Exposes <StructureNoplural> data.
        ;;; </summary>
        public readwrite property <StructurePlural>, @DbSet<<StructureNoplural>>

</STRUCTURE_LOOP>
        ;;; <summary>
        ;;;
        ;;; </summary>
        protected override method OnModelCreating, void
            parm, @ModelBuilder
        proc
            parm.Ignore(^typeof(AlphaDesc))
            parm.Ignore(^typeof(DataObjectMetadataBase))

.region "Composite key definitions"

            ;;Entities with a single primary key segment have the key declared to EF via a
            ;;{Key} attribute on the appropriate property in the data model, but only one {key}
            ;;attribute can be used in a class, so keys with multiple segments are defined
            ;;using the "Fluent API" here.

<STRUCTURE_LOOP>
  <IF STRUCTURE_ISAM>
    <PRIMARY_KEY>
      <IF MULTIPLE_SEGMENTS>
            parm.Entity<<StructureNoplural>>().HasKey(<SEGMENT_LOOP>"<FieldSqlname>"<,></SEGMENT_LOOP>)
      </IF MULTIPLE_SEGMENTS>
    </PRIMARY_KEY>
  </IF STRUCTURE_ISAM>
  <IF STRUCTURE_RELATIVE>
            parm.Entity<<StructureNoplural>>().HasKey("RecordNumber")
  </IF STRUCTURE_RELATIVE>
</STRUCTURE_LOOP>

.endregion

.region "Tag filtering"

            ;;This code will currently only work for tags with:
            ;;   a single "field .operator. value" expression
            ;;   multiple "field .operator. value" expressions connected by AND operators
            ;;   multiple "field .operator. value" expressions connected by OR operators
            ;;
            ;;The code will not work for multi-part tags that use a combination of AND and OR operators

            data tagExpressions, @List<Tuple<Expression,TagConnector>>

<STRUCTURE_LOOP>
  <IF STRUCTURE_TAGS>
            ;------------------------------------
            ; Tags for <StructureNoplural>

            tagExpressions = new List<Tuple<Expression,TagConnector>>()
            data <structureNoplural>Param = Expression.Parameter(^typeof(<structureNoplural>))

    <TAG_LOOP>
            tagExpressions.Add(
            &   Tuple.Create<Expression,TagConnector>(
      <IF COMPARISON_EQ>
            &       Expression.Equal(
      <ELSE COMPARISON_GE>
            &       Expression.GreaterThanOrEqual(
      <ELSE COMPARISON_GT>
            &       Expression.GreaterThan(
      <ELSE COMPARISON_LE>
            &       Expression.LessThanOrEqual(
      <ELSE COMPARISON_LT>
            &       Expression.LessThan(
      <ELSE COMPARISON_NE>
            &       Expression.NotEqual(
      </IF>
            &           Expression.Call(
            &               ^typeof(EF),
            &               "Property",
            &               new Type[#] { ^typeof(<TAGLOOP_FIELD_SNTYPE>) },
            &               <structureNoplural>Param,
            &               Expression.Constant("<TagloopFieldSqlname>")
            &           ),
            &           Expression.Constant(<TAGLOOP_TAG_VALUE>)
            &       ),
      <IF CONNECTOR_NONE OR CONNECTOR_AND>
            &       TagConnector.AndExpression
      <ELSE CONNECTOR_OR>
            &       TagConnector.OrExpression
      </IF>
            &   )
            &)

    </TAG_LOOP>
            parm.AddGlobalTagFilterAndOr<<structureNoplural>>(<structureNoplural>Param,tagExpressions)
            init tagExpressions

  </IF STRUCTURE_TAGS>
</STRUCTURE_LOOP>
;//
;//
;//<STRUCTURE_LOOP>
;//  <IF STRUCTURE_TAGS>
;//            data <structureNoplural>Param = Expression.Parameter(^typeof(<structureNoplural>))
;//            parm.AddGlobalTagFilter<<StructureNoplural>>(<structureNoplural>Param,
;//    <TAG_LOOP>
;//      <IF COMPARISON_EQ>
;//            &                Expression.Equal
;//      </IF COMPARISON_EQ>
;//      <IF COMPARISON_GE>
;//            &                Expression.GreaterThanOrEqual
;//      </IF COMPARISON_GE>
;//      <IF COMPARISON_GT>
;//            &                Expression.GreaterThan
;//      </IF COMPARISON_GT>
;//      <IF COMPARISON_LE>
;//            &                Expression.LessThanOrEqual
;//      </IF COMPARISON_LE>
;//      <IF COMPARISON_LT>
;//            &                Expression.LessThan
;//      </IF COMPARISON_LT>
;//      <IF COMPARISON_NE>
;//            &                Expression.NotEqual
;//      </IF COMPARISON_NE>
;//            &                (
;//            &                    Expression.Call
;//            &                    (
;//            &                        ^typeof(EF),
;//            &                        "Property",
;//            &                        new Type[#] { ^typeof(<TAGLOOP_FIELD_SNTYPE>) },
;//            &                        <structureNoplural>Param,
;//            &                        Expression.Constant("<TagloopFieldSqlname>")
;//            &                    ),
;//            &                    Expression.Constant(<TAGLOOP_TAG_VALUE>)
;//            &                )<,>
;//    </TAG_LOOP>
;//            & )
;//
;//  </IF STRUCTURE_TAGS>
;//</STRUCTURE_LOOP>
.endregion

<IF DEFINED_ENABLE_RELATIONS>
.region "Entity Relationships"

            <STRUCTURE_LOOP>
            <IF STRUCTURE_RELATIONS AND HARMONYCORE_RELATIONS_ENABLED>
            ;;--------------------------------------
            ;; Relationships from <STRUCTURE_NOPLURAL>

            <RELATION_LOOP_RESTRICTED>
;// A
            <IF MANY_TO_ONE_TO_MANY>
             ;; <STRUCTURE_NOPLURAL>.<RELATION_FROMKEY> (many) --> (one) --> (many) <RELATION_TOSTRUCTURE_NOPLURAL>.<RELATION_TOKEY>
             ;;    Type          : A
             ;;    From segments : <FROM_KEY_SEGMENT_LOOP_RESTRICTED><IF SEG_TYPE_FIELD><SEGMENT_NAME>(<FIELD_SPEC>)</IF SEG_TYPE_FIELD><IF SEG_TYPE_LITERAL>Literal(<SEGMENT_LITVAL>)</IF SEG_TYPE_LITERAL><,> </FROM_KEY_SEGMENT_LOOP_RESTRICTED>
             ;;    To segments   : <TO_KEY_SEGMENT_LOOP><IF SEG_TYPE_FIELD><SEGMENT_NAME>(<FIELD_SPEC>)</IF SEG_TYPE_FIELD><IF SEG_TYPE_LITERAL>Literal(<SEGMENT_LITVAL>)</IF SEG_TYPE_LITERAL><,> </TO_KEY_SEGMENT_LOOP>

             parm.AddOneToOneToManyRelation<<StructureNoplural>, <RelationTostructureNoplural>>("<HARMONYCORE_RELATION_NAME>", "KEY_<RELATION_FROMKEY>", "<HARMONYCORE_FROM_RELATION_NAME>", "KEY_<RELATION_TOKEY>")
            </IF MANY_TO_ONE_TO_MANY>
;// B
            <IF ONE_TO_ONE_TO_ONE>
             ;; <STRUCTURE_NOPLURAL>.<RELATION_FROMKEY> (one) --> (one) --> (one) <RELATION_TOSTRUCTURE_NOPLURAL>.<RELATION_TOKEY>
             ;;    Type          : B
             ;;    From segments : <FROM_KEY_SEGMENT_LOOP><IF SEG_TYPE_FIELD><SEGMENT_NAME>(<FIELD_SPEC>)</IF SEG_TYPE_FIELD><IF SEG_TYPE_LITERAL>Literal(<SEGMENT_LITVAL>)</IF SEG_TYPE_LITERAL><,> </FROM_KEY_SEGMENT_LOOP>
             ;;    To segments   : <TO_KEY_SEGMENT_LOOP><IF SEG_TYPE_FIELD><SEGMENT_NAME>(<FIELD_SPEC>)</IF SEG_TYPE_FIELD><IF SEG_TYPE_LITERAL>Literal(<SEGMENT_LITVAL>)</IF SEG_TYPE_LITERAL><,> </TO_KEY_SEGMENT_LOOP>

             parm.AddOneToOneToOneRelation<<StructureNoplural>, <RelationTostructureNoplural>>("<HARMONYCORE_RELATION_NAME>", "KEY_<RELATION_FROMKEY>", "<HARMONYCORE_FROM_RELATION_NAME>", "KEY_<RELATION_TOKEY>")
            </IF ONE_TO_ONE_TO_ONE>
;// C
            <IF ONE_TO_ONE>
            ;; <STRUCTURE_NOPLURAL>.<RELATION_FROMKEY> (one) --> (one) <RELATION_TOSTRUCTURE_NOPLURAL>.<RELATION_TOKEY>
            ;;    Type          : C
            ;;    From segments : <FROM_KEY_SEGMENT_LOOP_RESTRICTED><IF SEG_TYPE_FIELD><SEGMENT_NAME>(<FIELD_SPEC>)</IF SEG_TYPE_FIELD><IF SEG_TYPE_LITERAL>Literal(<SEGMENT_LITVAL>)</IF SEG_TYPE_LITERAL><,> </FROM_KEY_SEGMENT_LOOP_RESTRICTED>
            ;;    To segments   : <TO_KEY_SEGMENT_LOOP><IF SEG_TYPE_FIELD><SEGMENT_NAME>(<FIELD_SPEC>)</IF SEG_TYPE_FIELD><IF SEG_TYPE_LITERAL>Literal(<SEGMENT_LITVAL>)</IF SEG_TYPE_LITERAL><,> </TO_KEY_SEGMENT_LOOP>

            parm.AddOneToOneRelation<<StructureNoplural>, <RelationTostructureNoplural>>("<HARMONYCORE_RELATION_NAME>", "KEY_<RELATION_FROMKEY>", "KEY_<RELATION_TOKEY>")
            </IF ONE_TO_ONE>
;// D
            <IF ONE_TO_MANY_TO_ONE>
            ;; <STRUCTURE_NOPLURAL>.<RELATION_FROMKEY> (one) --> (many) --> (one) <RELATION_TOSTRUCTURE_NOPLURAL>.<RELATION_TOKEY>
            ;;    Type          : D
            ;;    From segments : <FROM_KEY_SEGMENT_LOOP><IF SEG_TYPE_FIELD><SEGMENT_NAME>(<FIELD_SPEC>)</IF SEG_TYPE_FIELD><IF SEG_TYPE_LITERAL>Literal(<SEGMENT_LITVAL>)</IF SEG_TYPE_LITERAL><,> </FROM_KEY_SEGMENT_LOOP>
            ;;    To segments   : <TO_KEY_SEGMENT_LOOP_RESTRICTED><IF SEG_TYPE_FIELD><SEGMENT_NAME>(<FIELD_SPEC>)</IF SEG_TYPE_FIELD><IF SEG_TYPE_LITERAL>Literal(<SEGMENT_LITVAL>)</IF SEG_TYPE_LITERAL><,> </TO_KEY_SEGMENT_LOOP_RESTRICTED>

            parm.AddOneToManyToOneRelation<<StructureNoplural>, <RelationTostructureNoplural>>("<HARMONYCORE_RELATION_NAME>", "KEY_<RELATION_FROMKEY>", "<HARMONYCORE_FROM_RELATION_NAME>", "KEY_<RELATION_TOKEY>")
            </IF ONE_TO_MANY_TO_ONE>
;// E
            <IF ONE_TO_MANY>
            ;; <STRUCTURE_NOPLURAL>.<RELATION_FROMKEY> (one) --> (many) <RELATION_TOSTRUCTURE_NOPLURAL>.<RELATION_TOKEY>
            ;;    Type          : E
            ;;    From segments : <FROM_KEY_SEGMENT_LOOP><IF SEG_TYPE_FIELD><SEGMENT_NAME>(<FIELD_SPEC>)</IF SEG_TYPE_FIELD><IF SEG_TYPE_LITERAL>Literal(<SEGMENT_LITVAL>)</IF SEG_TYPE_LITERAL><,> </FROM_KEY_SEGMENT_LOOP>
            ;;    To segments   : <TO_KEY_SEGMENT_LOOP><IF SEG_TYPE_FIELD><SEGMENT_NAME>(<FIELD_SPEC>)</IF SEG_TYPE_FIELD><IF SEG_TYPE_LITERAL>Literal(<SEGMENT_LITVAL>)</IF SEG_TYPE_LITERAL><,> </TO_KEY_SEGMENT_LOOP>

            parm.AddOneToManyRelation<<StructureNoplural>, <RelationTostructureNoplural>>("<HARMONYCORE_RELATION_NAME>", "KEY_<RELATION_FROMKEY>", "KEY_<RELATION_TOKEY>")
            </IF ONE_TO_MANY>
            </RELATION_LOOP_RESTRICTED>
            </IF STRUCTURE_RELATIONS>
            </STRUCTURE_LOOP>
.endregion
</IF DEFINED_ENABLE_RELATIONS>

            ;;-----------------------------------------------
            ;;If we have a OnModelCreatingCustom method, call it

            OnModelCreatingCustom(parm)

            ;;-----------------------------------------------
            ;;All done, call the code in our base class

            parent.OnModelCreating(parm)

        endmethod

        ;;Declare the OnModelCreatingCustom partial method
        ;;This method can be implemented in a partial class to provide custom code
        partial static method OnModelCreatingCustom, void
            builder, @ModelBuilder
        endmethod

    endclass

endnamespace