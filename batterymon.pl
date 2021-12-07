#!/usr/bin/perl

use Glib qw/TRUE FALSE/;
use Gtk2 '-init';

sub progress_timeout
{
	Gtk2->main_quit;
}

$acpi = `acpi`;
$acpi =~ /Battery 0: (.*), (\d+)%(.*)/;
$charge = $2;
$fcharge = $charge/100;

$window = Gtk2::Window->new('toplevel');
$window->set_resizable(TRUE);
$window->set_title("Battery Status");
$window->set_border_width(0);
$window->set_decorated(FALSE);
$window->set_position('GTK_WIN_POS_CENTER');

$vbox = Gtk2::VBox->new(FALSE, 0);
$vbox->set_border_width(0);
$window->add($vbox);
$vbox->show;

# Create a centering alignment object;
$align = Gtk2::Alignment->new(0, 0, 0, 0);
$vbox->pack_start($align, FALSE, FALSE, 0);
$align->show;

# Create the Gtk2::ProgressBar and attach it to the window reference.
$pbar = Gtk2::ProgressBar->new;
$window->{pbar} = $pbar;
$align->add($pbar);

$pbar->set_fraction($fcharge);
$pbar->set_text($charge."%");
$pbar->show;

$pbar->{timer} = Glib::Timeout->add(1000, \&progress_timeout, $pbar);

$window->show;

Gtk2->main;
