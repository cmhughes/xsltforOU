<?xml version="1.0"?>
<!--*                                    *-->
<!--* Generated from MathBook XML source *-->
<!--*    on 2014-12-08T19:19:18Z    *-->
<!--*                                    *-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="text"/>
  <xsl:template name="cross-reference">
    <xsl:param name="cref"/>
    <xsl:choose>
      <xsl:when test="$cref='figure-function-derivative'">Figure 5</xsl:when>
      <xsl:when test="$cref='tab-firsttablereference'">Table 3</xsl:when>
      <xsl:when test="$cref='tab-anotherservice'">Table 4</xsl:when>
      <xsl:when test="$cref='figure-function-derivativecm'">Figure 1</xsl:when>
      <xsl:when test="$cref='cmh'">Figure 2</xsl:when>
      <xsl:when test="$cref='tab-anotherservice'">Table 1</xsl:when>
      <xsl:otherwise>
        <xsl:message terminate="no">
                  Warning
                  <xsl:value-of select="$cref"/>
                  cross reference not found. 
                  <xsl:text>???</xsl:text></xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
</xsl:stylesheet>
