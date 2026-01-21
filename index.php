<?php
$nav_links = [
    'home' => ['label' => 'Home', 'url' => '#home'],
    'menu' => ['label' => 'Menu', 'url' => '#menu'],
    'testimonials' => ['label' => 'Testimonials', 'url' => '#testimonials'],
    'about' => ['label' => 'About', 'url' => '#about'],
    'gallery' => ['label' => 'Gallery', 'url' => '#gallery'],
    'contact' => ['label' => 'Contact', 'url' => '#contact']
];
?>
<nav class="navbar">
    <div class="container">
        <div class="logo">
            <i class="fas fa-coffee"></i>
            <span>Coffee Lounge</span>
        </div>
        <div class="nav-links" id="navLinks">
            <?php foreach ($nav_links as $key => $link): ?>
                <a href="<?php echo $link['url']; ?>" 
                   class="<?php echo ($current_page == $key) ? 'active' : ''; ?>">
                    <?php echo $link['label']; ?>
                </a>
            <?php endforeach; ?>
        </div>
        <div class="menu-toggle" id="menuToggle">
            <i class="fas fa-bars"></i>
        </div>
    </div>
</nav>