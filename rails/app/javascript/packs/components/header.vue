<template>
    <div>
        <ul id="dropdown" class="dropdown-content">
            <li><a href="#">Top</a></li>
            <li><a href="#">About</a></li>
            <li><a href="#">Contact</a></li>
        </ul>
        <nav>
            <div class="nav-wrapper container">
                <div class="brand-logo left">Todo Application</div>
                <ul class="right hide-on-med-and-down">
                    <li><router-link to="/home">Top</router-link></li>
                    <li><router-link to="/about">About</router-link></li>
                    <li><router-link to="/contact">Contact</router-link></li>
                </ul>
                <ul class="right hide-on-large-only">
                    <li>
                        <a class="dropdown-button" href="#!" data-activates="dropdown">
                            Menu<i class="material-icons right">arrow_drop_down</i>
                        </a>
                    </li>
                </ul>
            </div>
        </nav>
    </div>
</template>