<?xml version='1.0'?> <!-- As XML file -->

<!--********************************************************************
Copyright 2013 Robert A. Beezer

This file is part of MathBook XML.

MathBook XML is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 2 or version 3 of the
License (at your option).

MathBook XML is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with MathBook XML.  If not, see <http://www.gnu.org/licenses/>.
*********************************************************************-->

<!-- Identify as a stylesheet -->
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
  xmlns:xml="http://www.w3.org/XML/1998/namespace"
  xmlns:exsl="http://exslt.org/common"
  xmlns:date="http://exslt.org/dates-and-times"
  extension-element-prefixes="exsl date"
  >

<!-- language settings -->
<xsl:import href="./languages/mathbook-language-en.xsl" />

<!-- 
     cross references 
<xsl:import href="../crossrefs.xsl" />
-->
<xsl:import href="CrossRefs.xsl" />

<!-- Intend output for rendering by a web browser -->
<xsl:output method="xml" encoding="utf-8"/>

<!-- numbered figures -->
<xsl:template match="figure" mode="number">
  <xsl:number level="multiple" count="figure" />
</xsl:template>

<!-- numbered tables -->
<xsl:template match="table" mode="number">
  <xsl:number level="multiple" count="table" />
</xsl:template>

<!-- names such as Figure, Table, Section, etc-->
<xsl:template match="*" mode="type-name">
  <xsl:call-template name="type-name">
    <xsl:with-param name="generic" select="local-name(.)" />
  </xsl:call-template>
</xsl:template>

<!-- cross references-->
<xsl:template match="*" mode="cross-reference">
  <!-- call the cross reference template -->
  <xsl:call-template name="cross-reference">
    <xsl:with-param name="cref" select="./@object" />
  </xsl:call-template>
</xsl:template>

<!-- cref: (clever, (well, ish) ) Cross reference -->
<xsl:template match="cref">
  <xsl:apply-templates select="." mode="cross-reference"/>
</xsl:template>

<!-- update cross reference auxilary file -->
<xsl:template match="*" name="set-up-auxilary-file">
  <!-- out put auxilary data to its own xml file 
       This template essentially creates an xsl file that looks something like the following:
<xsl:template name="cross-reference">
    <xsl:param name="cref" />
    <xsl:choose>
        <xsl:when test="$cref='figure-function-derivative'">        <xsl:text>Figure 1.1</xsl:text></xsl:when>
        <xsl:when test="$cref='tab-firsttablereference'">        <xsl:text>Table 3.2</xsl:text></xsl:when>
        <xsl:otherwise>
            <xsl:message terminate="no">Warning: <xsl:value-of select="$cref" /> cross reference not found.&#xa;</xsl:message>
        <xsl:text>???</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>
  -->
  <exsl:document href="CrossRefs.xsl" method="xml" indent="yes">
    <xsl:comment>*                                    *</xsl:comment>
    <xsl:comment>* Generated from MathBook XML source *</xsl:comment>
    <xsl:comment>
      <xsl:text>*    on </xsl:text>
      <xsl:value-of select="date:date-time()" />
      <xsl:text>    *</xsl:text>
    </xsl:comment>
    <xsl:comment>*                                    *</xsl:comment><xsl:text>&#xa;</xsl:text>
    <!-- create an xsl stylesheet ... -->
    <xsl:element name="xsl:stylesheet">
    <!-- set the version -->
        <xsl:attribute name="version">1.0</xsl:attribute>
      <!-- xsl output method -->
      <xsl:element name="xsl:output">
        <xsl:attribute name="method">text</xsl:attribute>
      </xsl:element>
      <!-- create an xsl template -->
      <xsl:element name="xsl:template">
      <!-- set the name -->
          <xsl:attribute name="name">cross-reference</xsl:attribute>
        <!-- create an xsl param -->
        <xsl:element name="xsl:param">
          <xsl:attribute name="name">cref</xsl:attribute>
        </xsl:element>
        <!-- create an xsl choose -->
        <xsl:element name="xsl:choose">
          <!-- loop through each cross reference -->
          <!-- <xsl:for-each select="./section/cref"> -->
            <xsl:for-each select="./section/*/@xml:id">
              <!-- set up the bit that has <xsl:when test='figure-description'><xsl:text>Figure 1.3</xsl:text></xsl:when> -->
              <xsl:element name="xsl:when">
                <!-- ... this is the test='...' bit ... -->
                <xsl:attribute name="test"><xsl:text>$cref='</xsl:text><xsl:value-of select="current()"/><xsl:text>'</xsl:text></xsl:attribute>
                <!-- ... and the cref contains the bit we want, e.g Figure 1, Table 3, etc -->
                  <xsl:apply-templates select=".." mode="type-name"/>
                  <xsl:text> </xsl:text>
                  <xsl:apply-templates select=".." mode="number"/>
              </xsl:element>
            </xsl:for-each>
            <!-- set-up otherwise part -->
              <xsl:element name="xsl:otherwise">
                <xsl:element name="xsl:message"> 
                  <xsl:attribute name="terminate">no</xsl:attribute>
                  Warning
                  <xsl:element name="xsl:value-of"><xsl:attribute name="select">$cref</xsl:attribute></xsl:element>
                  cross reference not found. 
                  <xsl:element name="xsl:text">???</xsl:element>
                </xsl:element>
              </xsl:element>
          </xsl:element>
        </xsl:element>
      </xsl:element>
    </exsl:document>
  </xsl:template>

<!-- create chapters -->
<xsl:template match="chapter">
  <!-- set-up auxilary file containing cross reference information -->
  <xsl:call-template name="set-up-auxilary-file"/>
  <!-- chapters create a new html page, so need an html and a body tag -->
  <xsl:element name="html">
    <xsl:element name="script">
      <xsl:attribute name="type">text/javascript</xsl:attribute>
      <xsl:attribute name="src">myfile.js</xsl:attribute>
    </xsl:element>
    <xsl:element name="body">
      <xsl:attribute name="onload">setupCrossRefs()</xsl:attribute>
      <xsl:apply-templates />
    </xsl:element>
  </xsl:element>
</xsl:template>


<!-- sections simply need a div -->
<xsl:template match="section">
  <xsl:element name="div">
    <xsl:apply-templates />
  </xsl:element>
</xsl:template>

<!-- Figures | Tables and their captions -->
<xsl:template match="figure|table">
  <!-- create a div box <div class="figure">	-->
    <xsl:element name="div">
      <xsl:attribute name="class">
        <!-- this evaluates to figure or table, as appropriate-->
        <xsl:value-of select="name()"/>
      </xsl:attribute>
      <!-- If the Figure has an xml:id, then put that id in the Figure of the html
         and also create a cref attribute so that Javascript can use it to create 
         a cross reference e.g 
            <div class="figure" id="fig:function:derivative" cref="Figure 1"> -->
        <xsl:if test="@xml:id">
          <xsl:attribute name="id"><xsl:value-of select="@xml:id" /></xsl:attribute>
          <xsl:attribute name="cref">
            <xsl:apply-templates select="." mode="type-name"/>
            <xsl:text> </xsl:text>
            <xsl:apply-templates select="." mode="number"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:apply-templates />
      </xsl:element>
    </xsl:template>

<!-- Caption of a figure                           
     All the relevant information is in the parent node: Figure -->
<xsl:template match="figure/caption|table/caption">
  <xsl:element name="caption">
    <!-- Figure *name* (specified in language file as Figure)
       select=".." means go up one node level from figure/caption to figure -->
    <xsl:apply-templates select=".." mode="type-name"/>
    <!-- blank space between Figure and number -->
    <xsl:text> </xsl:text>
    <!-- Figure *number* -->
    <xsl:apply-templates select=".." mode="number"/>
    <!-- Use a colon followed by a space to separate Figure|Table <number> and the caption -->
      <xsl:text>: </xsl:text>
      <!-- Insert caption text -->
      <xsl:apply-templates />
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
