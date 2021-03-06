<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:math="http://www.w3.org/2005/xpath-functions/math"
	xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"
	xmlns:wdb="https://github.com/dariok/wdbplus"
	exclude-result-prefixes="xs math"
	version="3.0">
	
	<xsl:output indent="true"/>
	
	<xsl:import href="../string-pack.xsl"/>
	<xsl:import href="../word-pack.xsl"/>
	
	<xsl:template match="/">
		<xsl:variable name="entries">
			<xsl:apply-templates select="//w:p"/>
		</xsl:variable>
		
		<TEI xmlns="http://www.tei-c.org/ns/1.0">
			<teiHeader />
			<text>
				<body>
					<list>
						<xsl:for-each select="distinct-values($entries/*)">
							<xsl:sort select="normalize-space(current())" />
							<item>
								<xsl:sequence select="current()"/>
							</item>
						</xsl:for-each>
					</list>
				</body>
			</text>
		</TEI>
	</xsl:template>
	
	<xsl:template match="w:p">
		<xsl:variable name="val">
			<xsl:apply-templates select="w:r" />
		</xsl:variable>
		
		<xsl:variable name="step1" select="normalize-space(wdb:substring-after-if-starts(normalize-space($val), '-'))"/>
			
		<xsl:variable name="step2">
			<xsl:value-of select="wdb:substring-before($step1, 'siehe')"/>
		</xsl:variable>
		
		<xsl:variable name="step3">
			<xsl:analyze-string select="$step2" regex=" ?([XLIV]+|\d+)( \d+)?(-|,| f\.,?| ff\.,?|\n|$)">
				<xsl:non-matching-substring>
					<xsl:value-of select="normalize-space(.)"/>
				</xsl:non-matching-substring>
			</xsl:analyze-string>
		</xsl:variable>
		
		<xsl:variable name="step4">
			<xsl:analyze-string select="$step3" regex="([A-ZČ] ([^A-ZČ] )*[^A-ZČ(])">
				<xsl:matching-substring>
					<xsl:value-of select="replace(., ' ', '')"/>
				</xsl:matching-substring>
				<xsl:non-matching-substring>
					<xsl:value-of select="."/>
				</xsl:non-matching-substring>
			</xsl:analyze-string>
		</xsl:variable>
		
		<xsl:if test="string-length($step4) &gt; 0">
			<entry>
				<xsl:value-of select="$step4"/>
			</entry>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="w:r">
		<xsl:if test="w:rPr/w:vertAlign">
			<xsl:text>, </xsl:text>
		</xsl:if>
		<xsl:apply-templates select="w:t" />
	</xsl:template>
</xsl:stylesheet>