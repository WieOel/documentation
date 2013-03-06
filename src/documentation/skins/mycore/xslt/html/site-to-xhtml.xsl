<?xml version="1.0"?>

<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:i18n="http://apache.org/cocoon/i18n/2.1"
                exclude-result-prefixes="i18n">

    <xsl:import href="../../../common/xslt/html/site-to-xhtml.xsl" />

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    main template
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <xsl:template match="site">

<xsl:call-template name="doctype" />

<html>
    <head>
        <xsl:call-template name="html-meta" />
        <xsl:call-template name="meta-data" />
        <xsl:call-template name="meta-title" />
        <xsl:call-template name="meta-icon" />
        <xsl:call-template name="meta-css" />
        <xsl:call-template name="meta-script" />
    </head>

    <body>
        <div class="container">

            <div class="row">
                <div id="header" class="span12">
                    <xsl:call-template name="site-logo" />
                </div>
            </div>

            <div class="row">
                <div id="topnav" class="span12">
                    <div id="nav_block">
                        <xsl:apply-templates select="ul[@id='tabs']"/>
                    </div>
                </div>
            </div>

            <div class="row">
                <div id="main" class="span12">

                    <div class="row">
                        <!-- use 3 columns for menu, if there is one -->
                        <xsl:choose>
                            <xsl:when test="div[@id='menu']/ul/li">
                                <div id="subnav" class="span3">
                                    <xsl:call-template name="menu"/>
                                    <script type="text/javascript"
                                            language="javascript">
                                            $(function() {
                                                $("ul li div").click(function() {
                                                    $(this).parent().children("ul").slideToggle();
                                                });
                                            });
                                    </script>
                                </div>

                                <div id="content_block" class="span8">
                                    <xsl:apply-templates select="div[@id='content']"/>
                                </div>
                            </xsl:when>
                            <xsl:otherwise>
                                <div id="lefty" class="span1">

                                </div>
                                <div id="content" class="span10">
                                    <xsl:apply-templates select="div[@id='content']"/>
                                </div>
                            </xsl:otherwise>
                        </xsl:choose>

                        <div id="righty" class="span1">

                        </div>
                    </div>

                </div>
            </div>

            <div class="row">
                <div id="footer" class="span12">
                </div>
            </div>

        </div>
    </body>
</html>

    </xsl:template>


<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    doctype
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <xsl:template name="doctype">
        <xsl:variable name="doc_string"><![CDATA[<!DOCTYPE html>]]>
</xsl:variable>
        <xsl:value-of select="$doc_string" disable-output-escaping = "yes" />
    </xsl:template>

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    meta-title
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <xsl:template name="meta-title">
        <title>
            <xsl:value-of select="div[@id='content']/h1"/>
            <xsl:if test="$config/motd">
                <xsl:for-each select="$config/motd/motd-option">
                    <xsl:choose>
                        <xsl:when test="@starts-with='true'">
                            <xsl:if test="starts-with($path, @pattern)">
                                <xsl:if test="normalize-space(motd-title) != ''">
                                    <xsl:text> (</xsl:text>
                                    <xsl:value-of select="motd-title"/>
                                    <xsl:text>)</xsl:text>
                                </xsl:if>
                            </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:if test="contains($path, @pattern)">
                                <xsl:if test="normalize-space(motd-title) != ''">
                                    <xsl:text> (</xsl:text>
                                    <xsl:value-of select="motd-title"/>
                                    <xsl:text>)</xsl:text>
                                </xsl:if>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:if>
        </title>
    </xsl:template>

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    meta-icon
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <xsl:template name="meta-icon">
        <xsl:if test="//skinconfig/favicon-url"><link rel="shortcut icon">
          <xsl:attribute name="href">
            <xsl:value-of select="concat($root,//skinconfig/favicon-url)"/>
          </xsl:attribute></link>
        </xsl:if>
    </xsl:template>

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    meta-css
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <xsl:template name="meta-css">
        <link href = "{$root}skin/central.css"
              type = "text/css"
              rel  = "stylesheet" />
    </xsl:template>

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    meta-script
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <xsl:template name="meta-script">
        <script type="text/javascript"
                language="javascript"
                src="{$root}skin/jquery-1.7.1.min.js"></script>
<!--
        <script type="text/javascript"
                language="javascript"
                src="{$root}skin/getBlank.js"></script>
        <script type="text/javascript"
                language="javascript"
                src="{$root}skin/getMenu.js"></script>
        <script type="text/javascript"
                language="javascript"
                src="{$root}skin/fontsize.js"></script>
-->
    </xsl:template>

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    site-logo
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <xsl:template name="site-logo">
        <a href="{$root}"><img src = "{$root}images/logo_mycore.png"
             id  = "mycore_logo"
             alt = "MyCoRe Logo" /></a>
    </xsl:template>

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub menu block
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
    <xsl:template name="menu">
        <div id="submenu">
            <xsl:for-each select = "div[@id='menu']/ul/li">
                <xsl:call-template name = "innermenuli" >
                    <xsl:with-param name="id" select="concat('1_', position())"/>
                    <xsl:with-param name="position" select="position()" />
                </xsl:call-template>
            </xsl:for-each>
        </div>
    </xsl:template>

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    sub menu
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

    <xsl:template name="innermenuli">

        <xsl:param name="id"/>
        <xsl:param name="position" />

        <xsl:variable name="tagid">
            <xsl:choose>
                <xsl:when test="descendant-or-self::node()/li/div/@class='current'">
                    <xsl:value-of select="concat('menu_selected_',$id)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('menu_',concat(font,$id))"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="whichGroup">
            <xsl:choose>
                <xsl:when test="descendant-or-self::node()/li/div/@class='current'">block_level_two_active</xsl:when>
                <xsl:otherwise>block_level_two</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

<!-- menu title -->
        <xsl:choose>
          <xsl:when test="$position = 1">
            <xsl:call-template name = "innermenulientry" >
              <xsl:with-param name="id"         select="$id"/>
              <xsl:with-param name="tagid"      select="$tagid"/>
              <xsl:with-param name="whichGroup" select="'block_level_one'"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
              <li id="{$tagid}Title">
                  <xsl:choose>
                    <xsl:when test="$whichGroup = 'block_level_two_active'">
                        <xsl:attribute name="class">menu_entry_block_active</xsl:attribute>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:attribute name="class">menu_entry_block</xsl:attribute>
                    </xsl:otherwise>
                  </xsl:choose>
                  <div class="block_title"><xsl:value-of select="h1"/></div>
                  <xsl:call-template name = "innermenulientry" >
                    <xsl:with-param name="id"         select="$id"/>
                    <xsl:with-param name="tagid"      select="$tagid"/>
                    <xsl:with-param name="whichGroup" select="$whichGroup"/>
                  </xsl:call-template>
              </li>
          </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="innermenulientry">
        <xsl:param name="id"/>
        <xsl:param name="tagid"/>
        <xsl:param name="whichGroup" />

<!-- menu entry -->
        <ul class="{$whichGroup}" id="{$tagid}">

            <xsl:for-each select= "ul/li">
                <xsl:choose>

    <!-- linked entry -->
                    <xsl:when test="a">
                        <li class="menu_entry">
                            <a>
                                <xsl:attribute name="href">
                                    <xsl:value-of select="a/@href"/>
                                </xsl:attribute>
                                <xsl:if test="a/@title!=''">
                                    <xsl:attribute name="title">
                                        <xsl:value-of select="a/@title"/>
                                    </xsl:attribute>
                                </xsl:if>
                                <xsl:value-of select="a"/>
                            </a>
                        </li>
                    </xsl:when>

    <!-- active entry -->
                    <xsl:when test="div/@class='current'">
                        <li class="menu_entry_active">
                            <div class="block_title">
                                <xsl:value-of select="div" />
                            </div>
                        </li>
                    </xsl:when>

    <!-- default entry -->
                    <xsl:otherwise>
                        <xsl:call-template name = "innermenuli">
                            <xsl:with-param name="id" select="concat($id, '_', position())"/>
                        </xsl:call-template>
                    </xsl:otherwise>

                </xsl:choose>
            </xsl:for-each>
        </ul>
    </xsl:template>

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    pdf link
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->

<!-- TODO: remove inline styles -->

    <xsl:template match="div[@id='skinconf-pdflink']">
        <xsl:if test="not($config/disable-pdf-link) or $disable-pdf-link = 'false'">
            <div class="pdflink" style="position: relative;float: right;" title="Portable Document Format">
                <a style="display: block;text-align: center;" href="{$filename-noext}.pdf" class="dida">
                    <img class="skin" style="display: block;" src="{$root}images/pdfdoc.gif" alt="PDF -icon" />
                </a>
            </div>
        </xsl:if>
    </xsl:template>

<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->
<!-- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -->


</xsl:stylesheet>
