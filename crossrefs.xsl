<?xml version='1.0'?> <!-- As XML file -->

<!-- cross reference file, eventually generated automagically, hopefully -->

<!-- Identify as a stylesheet -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:xml="http://www.w3.org/XML/1998/namespace" 
    xmlns:date="http://exslt.org/dates-and-times"
    extension-element-prefixes="date"
>

<!-- Output methods here are just text -->
<xsl:output method="text" />

<!-- List of cross references -->
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


</xsl:stylesheet>
