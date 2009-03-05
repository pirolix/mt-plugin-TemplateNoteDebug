package MT::Plugin::OMV::TemplateNoteDebug;

use vars qw( $MYNAME $VERSION $VERBOSE );
$MYNAME = 'TemplateNoteDebug';
$VERSION = '1.00';

use MT;
use base qw( MT::Plugin );
my $plugin = __PACKAGE__->new ({
        name => $MYNAME,
        version => $VERSION,
        author_name => '<MT_TRANS phrase="Piroli YUKARINOMIYA">',
        author_link => "http://www.magicvox.net/?$MYNAME",
#        doc_link => "",
        system_config_template => \&config_template,
        settings => new MT::PluginSettings ([
            ['template', { Default => undef }],
        ]),
        description => <<PERLHEREDOC,
<MT_TRANS phrase="Enable you to easily embed the debugging message with MTTemplateNote tag.">
PERLHEREDOC
});
MT->add_plugin ($plugin);

sub instance { $plugin; }



### Configuration template
sub config_template {
    return <<PERLHEREDOC;
    <mtapp:setting
        id="template"
        label="<__trans phrase="Template for debug">">
<textarea name="template" id="template" class="full-width" rows="10" cols="60"><TMPL_VAR NAME=TEMPLATE ESCAPE=HTML></textarea>
    </mtapp:setting>
PERLHEREDOC
}

### Over-ride the function of MTTemplateNote tag
MT->instance->component('core')->registry('tags', 'function', 'TemplateNote', sub {
    my ($ctx, $args) = @_;
    my $tmpl = &instance->get_config_value ('template')
        or return '';
    $tmpl =~ s/%\{([^}]+)\}/$args->{$1} || ''/eg;
    $tmpl;
});

1;